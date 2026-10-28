{
  lib,
  buildNpmPackage,
  ironcalc,
  gitMinimal,
}:

buildNpmPackage {
  pname = "ironcalc-docs";
  inherit (ironcalc) version src;

  postPatch = ''
    cd docs
  '';

  npmDepsHash = "sha256-lH4HUUiVSGcF/5cSse0l2ZWial3tkwOO8peb5Wl35rI=";

  nativeBuildInputs = [
    gitMinimal
  ];

  # https://discourse.nixos.org/t/nix-build-of-vuepress-project-is-slow-or-hangs/56521/5
  buildPhase = ''
    runHook preBuild

    # Icons are expected in public/
    mkdir -p src/public
    cp -v src/*.svg src/*.png src/public/ || true

    npm run build > tmp 2>&1
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/share/doc/ironcalc
    cp -r src/.vitepress/dist/* $out/share/doc/ironcalc/
  '';

  meta = ironcalc.meta // {
    description = "Documentation for IronCalc";
  };
}
