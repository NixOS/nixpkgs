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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "omnom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xspzTRIYUJSdI2Z/FAS2ecLpEEmEVGIwlhjrS5Yxh2c=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-qOl6f83k91K7YNF7lBbL66lXb/XWbGHyXeN7ZTchsI8=";

  passthru.updateScript = nix-update-script { };

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

  passthru.tests = nixosTests.omnom;

  meta = {
    description = "Webpage bookmarking and snapshotting service";
    homepage = "https://github.com/asciimoo/omnom";
    license = lib.licenses.agpl3Only;
    teams = [ lib.teams.ngi ];
    mainProgram = "omnom";
  };
})
