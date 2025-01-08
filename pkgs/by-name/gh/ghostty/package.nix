{
  lib,
  stdenv,
  callPackage,
}:

let
  package = callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) { };
in
package.overrideAttrs (
  finalAttrs: oldAttrs: {
    pname = "ghostty";
    version = "1.0.1";

    outputs = [
      "out"
      "man"
      "shell_integration"
      "terminfo"
      "vim"
    ];

    # Point `nix edit`, etc. to the file that defines the attribute
    pos = builtins.unsafeGetAttrPos "src" finalAttrs;

    meta = lib.recursiveUpdate (oldAttrs.meta or { }) {
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
      mainProgram = "ghostty";
      maintainers = with lib.maintainers; [
        jcollie
        pluiedev
        getchoo
      ];
      outputsToInstall = [
        "out"
        "man"
        "shell_integration"
        "terminfo"
      ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  }
)
