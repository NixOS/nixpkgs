{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,

  # for addons
  buildNpmPackage,
  zip,
}:

buildGoModule (finalAttrs: {
  pname = "omnom";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "omnom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2D+hEOlyjCJQKnLBBO1cXeqTS/QUWraPWPtI8pCf9KM=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-dsS5w8JXIwkneWScOFzLSDiXq+clgK+RdYiMw0+FnvY=";

  passthru.updateScript = nix-update-script { };

  patches = [ ./0001-fix-minimal-go-version.patch ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
  ];

  postBuild =
    let
      omnom-addons = buildNpmPackage {
        pname = "omnom-addons";
        inherit (finalAttrs) version src;

        npmDepsHash = "sha256-sUn5IvcHWJ/yaqeGz9SGvGx9HHAlrcnS0lJxIxUVS6M=";
        sourceRoot = "${finalAttrs.src.name}/ext";
        npmPackFlags = [ "--ignore-scripts" ];

        nativeBuildInputs = [ zip ];

        postBuild = ''
          mkdir -p $out

          zip -r "$out/omnom_ext_src.zip" README.md src utils package* webpack.config.js

          pushd build
            zip "$out/omnom_ext_chrome.zip" ./* icons/* -x manifest_ff.json
            zip "$out/omnom_ext_firefox.zip" ./* icons/* -x manifest_ff.json
          popd
        '';

        postCheck = ''
          npm run build-test
        '';
      };
    in
    ''
      mkdir -p $out/share/addons

      # Copy Firefox and Chrome addons
      cp -r ${omnom-addons}/*.zip $out/share/addons
    '';

  postInstall = ''
    mkdir -p $out/share/examples

    cp -r static templates $out/share
    cp config.yml_sample $out/share/examples/config.yml
  '';

  meta = {
    description = "Webpage bookmarking and snapshotting service";
    homepage = "https://github.com/asciimoo/omnom";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.ngi ];
    mainProgram = "omnom";
  };
})
