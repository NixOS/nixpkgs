{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  nixosTests,

  # for addons
  buildNpmPackage,
  zip,
}:

buildGoModule (finalAttrs: {
  pname = "omnom";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "omnom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cG+cAsarbDqi3BLrIiSnH4VQS0fdfyMgkvbQvzKUXNw=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-meToyr93nmKLZ//h8Gc0rp2hc4vOV9ULU+FbBXmbDv8=";

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mkdir -p $out/share/addons

    # Copy Firefox and Chrome addons
    cp -r ${finalAttrs.passthru.omnom-addons}/*.zip $out/share/addons

    mkdir -p $out/share/examples

    cp -r static templates $out/share
    cp config.yml_sample $out/share/examples/config.yml
  '';

  passthru = {
    omnom-addons = buildNpmPackage (finalAttrs': {
      pname = "omnom-addons";
      inherit (finalAttrs) version src;

      npmDepsHash = "sha256-CIzp6/mBTuSaEFv0lk3d/GZyq1VRDvCSoqrujz4AG/E=";
      sourceRoot = "${finalAttrs'.src.name}/ext";
      npmPackFlags = [ "--ignore-scripts" ];

      nativeBuildInputs = [ zip ];

      # Fix path for the `static` directory
      postConfigure = ''
        substituteInPlace webpack.config.js \
        --replace-fail '"..", ".."' '".."'
      '';

      postBuild = ''
        mkdir -p $out

        zip -r "$out/omnom_ext_src.zip" README.md src utils package* webpack.config.js

        pushd build
          zip "$out/omnom_ext_chrome.zip" ./* icons/* -x manifest_ff.json
          cp manifest_ff.json manifest.json
          zip "$out/omnom_ext_firefox.zip" ./* icons/* -x manifest_ff.json
        popd
      '';

      postCheck = ''
        npm run build-test
      '';
    });

    tests = nixosTests.omnom;
  };

  meta = {
    description = "Webpage bookmarking and snapshotting service";
    homepage = "https://omnom.zone/";
    downloadPage = "https://github.com/asciimoo/omnom";
    changelog = "https://github.com/asciimoo/omnom/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.ngi ];
    mainProgram = "omnom";
  };
})
