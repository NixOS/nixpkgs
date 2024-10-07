{
  lib,
  libwebp,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pixlet";
  version = "0.33.5";

  src = fetchFromGitHub {
    owner = "tidbyt";
    repo = "pixlet";
    rev = "refs/tags/v${version}";
    hash = "sha256-xRvIyV26L9aJpyN2jPAi3esWxVJhRU+zDCF9cOED2vw=";
  };

  vendorHash = "sha256-SbdZylgQJenAAT5kOCPT0mdCs3H/1t1giiiQRB4D0Zo=";

  frontend = buildNpmPackage {
    inherit pname version src;

    npmDepsHash = "sha256-FTXgswfHVzan5wIiUJziB7VFhyBPurvswogJ8y8sVuk=";

    installPhase = ''
      cp -r dist $out
    '';
  };

  # inject frontend build into go embed
  patchPhase = ''
    runHook prePatch

    rm -rf dist
    cp -r ${frontend} dist

    runHook postPatch
  '';

  checkFlags =
    let
      skipTests = [
        "TestInitHTTP"
        "TestIsInRepo"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skipTests}$" ];

  buildInputs = [
    libwebp
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $GOPATH/bin/pixlet $out/bin/
  '';

  meta = {
    homepage = "https://github.com/tidbyt/pixlet";
    changelog = "https://github.com/tidbyt/pixlet/releases/tag/v${version}";
    description = "Build apps for pixel-based displays";
    maintainers = with lib.maintainers; [ jackwiseman ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "pixlet";
  };
}
