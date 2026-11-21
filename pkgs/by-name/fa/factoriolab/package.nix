{
  buildNpmPackage,
  dart-sass,
  fetchFromGitHub,
  lib,
  jq,
  makeWrapper,
  nix-update-script,
  stdenv, # for meta.broken
}:
buildNpmPackage rec {
  pname = "factoriolab";
  version = "4.16.5";

  src = fetchFromGitHub {
    owner = "factoriolab";
    repo = "factoriolab";
    tag = "v${version}";
    hash = "sha256-Xn3qOLIlts6O6pkwOILvaNYMzG55Sv8WAG2LSAqB3ok=";
    fetchLFS = true;
  };
  nativeBuildInputs = [
    makeWrapper
  ];

  npmDepsHash = "sha256-GJ2AXMTfgAzVXxdAd7rKoO+znuzICyjANGlEswAFbJQ=";
  # sharp is only used by the data scripts, not by `ng build`, and fails to build from source
  npmFlags = [ "--ignore-scripts" ];
  # By default angular tries to optimize fonts by inlining them
  # which needs internet access during building to download said fonts.
  # Internet access during build would necessitate turning this into a fixed output derivation
  # which is difficult as said fonts are not actually stable.
  # This disables font inlining completely in which case the fonts will be loaded on demand by your browser
  postPatch = ''
    ${lib.getExe jq} '.projects.factoriolab.architect.build.options += { "optimization": {"fonts": false } }' ./angular.json > angular.json.new
    mv -f angular.json.new angular.json
  '';

  # Use our dart-sass instead of the bundled binary, which can't run on NixOS
  preBuild = ''
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    cp -r dist/factoriolab/browser $out/share/factoriolab

    runHook postInstall
  '';
  passthru.updateScript = nix-update-script { };

  meta = {
    # last successful hydra build on darwin was in 2025
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/factoriolab/factoriolab";
    changelog = "https://github.com/factoriolab/factoriolab/releases/tag/v${version}";
    description = "Angular-based calculator for factory games like Factorio and Dyson Sphere Program";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ patrickdag ];
  };
}
