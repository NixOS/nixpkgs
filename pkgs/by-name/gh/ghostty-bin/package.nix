{
  lib,
  stdenvNoCC,
  _7zz,
  fetchurl,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ghostty-bin";
  version = "1.2.2";

  src = fetchurl {
    url = "https://release.files.ghostty.org/${finalAttrs.version}/Ghostty.dmg";
    hash = "sha256-gSuOOWZUzKKihCGmqEnieJJ8iP4xFeoSQIL536ka454=";
  };

  sourceRoot = ".";

  # otherwise fails to unpack with:
  # ERROR: Dangerous link path was ignored : Ghostty.app/Contents/Resources/terminfo/67/ghostty : ../78/xterm-ghostty
  unpackPhase = lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    runHook preUnpack
    7zz -snld x $src
    runHook postUnpack
  '';

  nativeBuildInputs = [
    _7zz
    makeBinaryWrapper
  ];

  postInstall = ''
    mkdir -p $out/Applications
    mv Ghostty.app $out/Applications/
    makeWrapper $out/Applications/Ghostty.app/Contents/MacOS/ghostty $out/bin/ghostty
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

     On linux we can move the original files and make symlinks to them
     but on darwin (when using the .app bundle) we need to copy the files
     in order to maintain signed integrity
  */
  resourceDir = "${placeholder "out"}/Applications/Ghostty.app/Contents/Resources";
  postFixup = ''
    mkdir -p $terminfo/share
    cp -r $resourceDir/terminfo $terminfo/share/terminfo

    cp -r $resourceDir/ghostty/shell-integration $shell_integration

    cp -r $resourceDir/vim/vimfiles $vim
  '';

  # Usually the multiple-outputs hook would take care of this, but
  # our manpages are in the .app bundle
  preFixup = ''
    mkdir -p $man/share
    cp -r $resourceDir/man $man/share/man
  '';

  outputs = [
    "out"
    "man"
    "shell_integration"
    "terminfo"
    "vim"
  ];

  meta = {
    description = "Fast, native, feature-rich terminal emulator pushing modern features";
    longDescription = ''
      Ghostty is a terminal emulator that differentiates itself by being
      fast, feature-rich, and native. While there are many excellent terminal
      emulators available, they all force you to choose between speed,
      features, or native UIs. Ghostty provides all three.
    '';
    homepage = "https://ghostty.org/";
    downloadPage = "https://ghostty.org/download";
    changelog = "https://ghostty.org/docs/install/release-notes/${
      builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Enzime ];
    mainProgram = "ghostty";
    outputsToInstall = [
      "out"
      "man"
      "shell_integration"
      "terminfo"
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
