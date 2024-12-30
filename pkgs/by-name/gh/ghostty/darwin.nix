{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  src = fetchurl {
    url = "https://release.files.ghostty.org/${finalAttrs.version}/Ghostty.dmg";
    sha256 = "sha256-CR96Kz9BYKFtfVKygiEku51XFJk4FfYqfXACeYQ3JlI=";
  };

  nativeBuildInputs = [
    _7zz
    makeBinaryWrapper
  ];

  sourceRoot = ".";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Ghostty.app $out/Applications/
    makeWrapper $out/Applications/Ghostty.app/Contents/MacOS/ghostty $out/bin/ghostty

    runHook postInstall
  '';

  /**
    Ghostty really likes all of it's resources to be in the same directory, so link them back after we split them

    - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/os/resourcesdir.zig#L11-L52
    - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/termio/Exec.zig#L745-L750
    - https://github.com/ghostty-org/ghostty/blob/4b4d4062dfed7b37424c7210d1230242c709e990/src/termio/Exec.zig#L818-L834

    terminfo and shell integration should also be installable on remote machines

    ```nix
    { pkgs, ... }: {
      environment.systemPackages = [ pkgs.ghostty.terminfo ];

      programs.bash = {
        interactiveShellInit = ''
          if [[ "$TERM" == "xterm-ghostty" ]]; then
            builtin source ${pkgs.ghostty.shell_integration}/bash/ghostty.bash
          fi
        '';
      };
    }
    ```
  */
  postFixup =
    let
      resources = "$out/Applications/Ghostty.app/Contents/Resources";
    in
    ''
      mkdir -p $man/share
      mv ${resources}/man $man/share/man
      ln -s $man/share/man ${resources}/man

      mkdir -p $terminfo/share
      mv ${resources}/terminfo $terminfo/share/terminfo
      ln -s $terminfo/share/terminfo ${resources}/terminfo

      mv ${resources}/shell-integration $shell_integration
      ln -s $shell_integration ${resources}/shell-integration

      mv ${resources}/vim/vimfiles $vim
      ln -s $vim ${resources}/vim/vimfiles
    '';

  meta = {
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
