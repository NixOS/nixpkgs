{
  lib,
  buildNpmPackage,
  buildGoModule,
  fetchFromGitHub,
}:

let
  # The node build requires its pinned esbuild version
  esbuild = buildGoModule rec {
    pname = "esbuild";
    version = "0.16.10";

    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      tag = "v${version}";
      hash = "sha256-plcI3p/m1tPODZNcBoP/kc3avO11oXww7NIA9wdX+Pc=";
    };

    vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";

    meta.mainProgram = "esbuild";
  };
in

buildNpmPackage rec {
  pname = "plotly-graph-card";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "dbuezas";
    repo = "lovelace-plotly-graph-card";
    tag = "v${version}";
    hash = "sha256-I0lP0Z0tUiuJ4cC2Ud4uePS8zEZIBNP5X3EEa9ZVQ24=";
  };

  npmDepsHash = "sha256-CwIx5/kAAY+PAjEkJi7/7NpApzFSoIfuIl7zmsaqicE=";

  # for ml-regression-logarithmic
  forceGitDeps = true;
  makeCacheWritable = true;

  # custom pinned esbuild version
  env.ESBUILD_BINARY_PATH = lib.getExe esbuild;

  installPhase = ''
    install -d $out
    install -m0644 dist/plotly-graph-card.js $out/
  '';

  meta = {
    description = "Highly customisable Lovelace card to plot interactive graphs. Brings scrolling, zooming, and much more";
    homepage = "https://github.com/dbuezas/lovelace-plotly-graph-card";
    changelog = "https://github.com/dbuezas/lovelace-plotly-graph-card/releases/tag/${src.tag}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.all;
  };
}
