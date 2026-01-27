{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (pkgs)
    bash
    buildPackages
    cygwin
    gnutar
    lib
    runCommand
    writeShellScript
    writeText
    ;

  nix = config.nix.package;

  bootScript = writeText "cygwin.ps1" (
    lib.replaceString "\n" "\r\n" ''
      $ErrorActionPreference = 'Stop'
      cp $PSScriptRoot\nix\var\nix\profiles\system\cygwin1.dll $PSScriptRoot\bin\cygwin1.dll
      $bash = "$PSScriptRoot${lib.replaceString "/" "\\" (lib.getBin bash).outPath}\bin\bash.exe"
      & $bash /nix/var/nix/profiles/system/activate
      if (!$?) { throw 'activation script failed' }
      & $bash --login -i $args
      if (!$?) { exit 1 }
    ''
  );

  cygwin1 = cygwin.newlib-cygwin.out + "/bin/cygwin1.dll";

in
{
  options.system.cygwin.tarball = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
  };

  config = {
    environment.etc."profile".text = ''
      export CYGWIN=winsymlinks=native\ $CYGWIN
    '';

    system.cygwin = {

      tarball =
        let
          install = writeText "install.ps1" (
            lib.replaceString "\n" "\r\n" ''
              param ([Parameter(Mandatory=$true)][string]$dir)

              $ErrorActionPreference = 'Stop'

              $_ = mkdir -force $dir

              fsutil file setCaseSensitiveInfo $dir enable
              if (!$?) { throw 'setCaseSensitiveInfo failed, this may require: Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux' }

              $_ = ni $dir\.test-target
              try {
                cmd /c mklink $dir\.test-link $dir\.test-target
                if (!$?) {
                  throw 'failed to create symbolic link: developer mode may need to be enabled'
                }
              } catch {
                throw
              } finally {
                rm $dir\.test-target
              }
              rm $dir\.test-link

              $env:CYGWIN = "winsymlinks=native"
              # create cygwin1.dll so that symlinks to it are created properly
              if(!(Test-Path $dir\bin\cygwin1.dll))
              {
                mkdir -f $dir\bin
                ni $dir\bin\cygwin1.dll
              }
              & $PSScriptRoot\tar -C $dir --force-local -xpf $PSScriptRoot\${config.system.cygwin.tarball.fileName}.tar${config.system.cygwin.tarball.extension}
              if (!$?) { throw 'failed to extract tarball' }
            ''
          );

          system = config.system.cygwin.toplevel;
        in
        (pkgs.callPackage ../../../lib/make-system-tarball.nix {
          # HACK: disable compression
          compressCommand = "cat";
          compressionExtension = "";

          contents = [
            {
              source = bootScript;
              target = "cygwin.ps1";
            }
          ];

          storeContents = [
            {
              object = system;
              symlink = "none";
            }
          ];

          extraCommands = buildPackages.writeShellScript "extra-commands.sh" ''
            chmod -R +w nix
            mkdir -p tmp nix/var/nix/profiles dev
            mkdir -m 01777 dev/{shm,mqueue}
            ln -s "$(realpath -s --relative-to=/nix/var/nix/profiles "${system}")" nix/var/nix/profiles/system
            find . -type l -print0 | while read -r -d "" f; do
                symlinkTarget=$(readlink "$f")
                if [[ "$symlinkTarget"/ != /nix/store* ]]; then
                    # skip this symlink as it doesn't point to /nix/store
                    continue
                fi

                relativeTarget=''${symlinkTarget#/}

                if [ ! -e "$relativeTarget" ]; then
                    echo "the symlink $f is broken, it points to $relativeTarget (which is missing)"
                fi

                relativeTarget=$(realpath -s --relative-to=$(dirname "$f") "$relativeTarget")

                echo "changing symlink $f -> $symlinkTarget to $relativeTarget"
                ln -snf "$relativeTarget" "$f"
            done

            mkdir -p "$out"/tarball
            cp "${install}" "$out"/tarball/install.ps1
            cp "${gnutar}/bin/tar.exe" "$out"/tarball/
            for dll in "${gnutar}/bin"/*.dll; do
              if [[ $dll != */cygwin1.dll ]]; then
                cp "$dll" "$out"/tarball/
              fi
            done
            cp "${cygwin1}" "$out"/tarball/
          '';
        });
    };
  };
}
