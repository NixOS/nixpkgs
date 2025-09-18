let
  nixpkgs = (import ./. { });

  inherit (nixpkgs.pkgsCross.x86_64-cygwin)
    bash
    buildEnv
    cacert
    coreutils
    lib
    nix
    runCommand
    writeShellScript
    writeText
    windows
    ;

  sw = buildEnv {
    name = "cygwin-root";

    paths = [
      bash
      nix
    ];

    nativeBuildInputs = [
      ./pkgs/build-support/setup-hooks/make-symlinks-relative.sh
    ];

    postBuild = ''
      find $out -type l -print0 | while read -r -d "" f; do
          local symlinkTarget
          symlinkTarget=$(readlink "$f")
          if [[ "$symlinkTarget"/ != /nix/store* ]]; then
              # skip this symlink as it doesn't point to /nix/store
              continue
          fi

          if [ ! -e "$symlinkTarget" ]; then
              echo "the symlink $f is broken, it points to $symlinkTarget (which is missing)"
          fi

          echo "rewriting symlink $f to be relative to /nix/store"
          ln -snrf "$symlinkTarget" "$f"
      done
    '';
  };

  system = runCommand "cygwin-system" { } ''
    mkdir "$out"
    ln -sr "${sw}" "$out"/sw
    ln -sr "${activate}" "$out"/activate
  '';

  cmd = writeText "cygwin.cmd" (
    lib.replaceString "\n" "\r\n" ''
      @echo off
      set PATH=%~dp0\bin;%PATH%
      set BASH="%~dp0${lib.replaceString "/" "\\" (lib.getBin bash).outPath}\bin\bash.exe"
      %BASH% nix\var\nix\profiles\system\activate || exit /b
      %BASH% --login -i || exit /b
    ''
  );

  activate = writeShellScript "activate" ''
    (
      export PATH=${lib.makeBinPath [ coreutils ]}:/bin
      ln -sr "${cacert}"/ssl /etc/ssl
    )
    exec "${lib.getBin bash}"/bin/bash --login -i
  '';

in
(nixpkgs.callPackage nixos/lib/make-system-tarball.nix {
  # HACK: disable compression
  compressCommand = "cat";
  compressionExtension = "";

  contents = [
    {
      source = lib.getBin windows.cygwin + "/bin/cygwin1.dll";
      target = "/bin/cygwin1.dll";
    }
    {
      source = cmd;
      target = "cygwin.cmd";
    }
  ];

  storeContents = [
    {
      object = system;
      symlink = "none";
    }
  ];

  extraCommands = ''
    mkdir etc tmp
    ln -sr "${system}" /nix/var/nix/profiles/system
  '';
})
// {
  inherit system;
}
