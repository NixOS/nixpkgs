{ lib
, buildGraalvmNativeImage
, fetchurl
, nix-update-script
, testers
, cljfmt
}:

buildGraalvmNativeImage rec {
  pname = "cljfmt";
  version = "0.11.2";

  src = fetchurl {
    url = "https://github.com/weavejester/${pname}/releases/download/${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-vEldQ7qV375mHMn3OUdn0FaPd+f/v9g+C+PuzbSTWtk=";
  };

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "-H:Log=registerResource:"
    "--initialize-at-build-time"
    "--diagnostics-mode"
    "--report-unsupported-elements-at-runtime"
    "--no-fallback"
  ];

  passthru.updateScript = nix-update-script { };

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = cljfmt;
    command = "cljfmt --version";
  };

  meta = with lib; {
    mainProgram = "cljfmt";
    description = "A tool for formatting Clojure code";
    homepage = "https://github.com/weavejester/cljfmt";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    changelog = "https://github.com/weavejester/cljfmt/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ sg-qwt ];
  };
}
