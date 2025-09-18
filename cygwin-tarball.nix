let
  nixpkgs = (import ./. { });

  inherit (nixpkgs.pkgsCross.x86_64-cygwin)
    bash
    buildEnv
    lib
    nix
    writeText
    windows
    ;

  system = buildEnv {
    name = "cygwin-root";

    paths = [
      bash
      nix
    ];

    nativeBuildInputs = [
      ./pkgs/build-support/setup-hooks/make-symlinks-relative.sh
    ];

    postBuild = ''
      while IFS= read -r -d $'\0' f; do
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

      done < <(find $out -type l -print0)
    '';
  };

  cmd = writeText "cygwin.cmd" (
    lib.replaceString "\n" "\r\n" ''
      @echo off
      set PATH=%~dp0\bin;%PATH%
      "%~dp0${lib.replaceString "/" "\\" system.outPath}\bin\bash.exe" --login -i
    ''
  );

  profile = writeText "profile" ''
    export PATH="${lib.getBin system}"/bin:$PATH
  '';

in
nixpkgs.callPackage nixos/lib/make-system-tarball.nix {
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
    {
      source = profile;
      target = "/etc/profile";
    }
  ];

  storeContents = [
    {
      object = system;
      symlink = "none";
    }
  ];

  extraCommands = ''
    mkdir tmp
  '';
}
