{
  fetchpatch,
  haskell,
  haskellPackages,
  installShellFiles,
  lib,
  extraComposeFunctions ? [ ],
}:
let
  inherit (haskell.lib.compose) justStaticExecutables overrideCabal;

  overrides = {
    patches = [
      # fix(json): handle unknown activity and result types gracefully
      # https://github.com/maralorn/nix-output-monitor/pull/321 (merged)
      (fetchpatch {
        url = "https://github.com/maralorn/nix-output-monitor/commit/d48ff7935da72a5a5764ee8c5358d38417b0f337.patch";
        stripLen = 1;
        hash = "sha256-83jk9DwNJZFbPzG6g9G8fW165hLolA1MjyerpqN9T3s=";
      })
    ];

    passthru.updateScript = ./update.sh;

    # nom has unit-tests and golden-tests
    # golden-tests call nix and thus can’t be run in a nix build.
    testTargets = [
      "unit-tests"
      "doc-tests"
    ];

    buildTools = [ installShellFiles ];
    postInstall = ''
      ln -s nom "$out/bin/nom-build"
      ln -s nom "$out/bin/nom-shell"
      chmod a+x $out/bin/nom-build
      installShellCompletion completions/*
    '';
  };
  raw-pkg = haskellPackages.callPackage ./generated-package.nix { };
in
lib.pipe raw-pkg (
  [
    (overrideCabal overrides)
    justStaticExecutables
  ]
  ++ extraComposeFunctions
)
