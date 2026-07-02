{
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  lib,
  helix,
  helix-unwrapped,
}:
let
  steelix-unwrapped = helix-unwrapped.overrideAttrs (
    finalAttrs: _: {
      pname = "steelix-unwrapped";
      version = "0-unstable-2026-05-21";

      src = fetchFromGitHub {
        owner = "mattwparas";
        repo = "helix";
        rev = "4d86612df48447088ef4190bf503fd54a7562aa9";
        hash = "sha256-qAUODNxHM9K6CrRCFgfBcbqzRd+YHiWn9fEfmIzrohA=";
      };

      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src pname version;
        hash = "sha256-6bu8sIM4So3AbnHHYbh8uu+rEB4IjMQjDgh7/AkLQs0=";
      };

      cargoBuildFlags = [
        "--package"
        "helix-term"
        "--features"
        "steel,git"
      ];

      # This fork is built from Helix master, whose loader expects tree-sitter
      # grammars with the platform-native extension (`.dylib` on Darwin) since
      # helix-editor/helix#14982. We reuse the grammars from `helix.runtime`, built
      # from the last Helix *release*, which still names them `.so` on Darwin, so
      # revert that commit to make the loader look for `.so`. Remove once a Helix
      # release ships #14982 and nixpkgs' grammars switch to `.dylib`.
      patches = [
        (fetchpatch {
          name = "revert-dylib-grammar-extension.patch";
          url = "https://github.com/helix-editor/helix/commit/430914b298a32653ab1847fdfdf2177a002be04c.patch";
          revert = true;
          hash = "sha256-4KUFppkso4/XwNU+mGIgLvl+mJXHZWkmaguYMy8oTyI=";
        })
      ];

      doInstallCheck = false;
    }
  );
in
(helix.override {
  helix-unwrapped = steelix-unwrapped;
}).overrideAttrs
  (
    _: previousAttrs: {
      pname = "steelix";
      strictDeps = true;

      meta = previousAttrs.meta // {
        description = "Helix editor with Steel (Scheme) scripting support";
        longDescription = ''
          Steelix is a fork of the Helix editor with Steel (Scheme) scripting support.
        '';
        homepage = "https://github.com/mattwparas/helix";
        changelog = "https://github.com/mattwparas/helix/blob/${steelix-unwrapped.src.rev}/CHANGELOG.md";
        license = lib.licenses.mpl20;
        mainProgram = "hx";
        maintainers = with lib.maintainers; [
          aciceri
          Ra77a3l3-jar
        ];
      };

      passthru = previousAttrs.passthru // {
        updateScript = ./update.sh;
      };
    }
  )
