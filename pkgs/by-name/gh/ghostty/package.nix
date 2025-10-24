{
  lib,
  stdenv,
  callPackage,
}:

let
  expression = if stdenv.hostPlatform.isDarwin then ./dmg.nix else ./source.nix;
  package = callPackage expression { };
in

package.overrideAttrs (
  finalAttrs: oldAttrs: {
    # Enforce these for a consistent API across different expressions
    outputs = [
      "out"
      "man"
      "shell_integration"
      "terminfo"
      "vim"
    ];

    # Point `nix edit`, etc. to the file that defines the attribute, not this
    # entry point
    pos = oldAttrs.pos or builtins.unsafeGetAttrPos "pname" finalAttrs;

    passthru = lib.recursiveUpdate {
      updateScript = ./update.nu;
    } oldAttrs.passthru or { };

    meta = lib.recursiveUpdate {
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
      maintainers = with lib.maintainers; [
        jcollie
        pluiedev
        getchoo
        Enzime
      ];
      mainProgram = "ghostty";
    } oldAttrs.meta or { };
  }
)
