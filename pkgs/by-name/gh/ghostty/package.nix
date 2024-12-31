{
  stdenvNoCC,
  callPackage,
  lib,
}:

let
  pname = "ghostty";
  version = "1.0.0";
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

    license = lib.licenses.mit;
    mainProgram = "ghostty";
    maintainers = with lib.maintainers; [
      jcollie
      pluiedev
      getchoo
      DimitarNestorov
    ];
    outputsToInstall = [
      "out"
      "man"
      "shell_integration"
      "terminfo"
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
in

if stdenvNoCC.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      outputs
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      outputs
      meta
      ;
  }
