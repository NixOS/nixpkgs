{ lib
, buildGraalvmNativeImage
, fetchurl
, nix-update-script
, testers
, cljfmt
}:

buildGraalvmNativeImage rec {
  pname = "cljfmt";
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/weavejester/cljfmt/releases/download/${version}/cljfmt-${version}-standalone.jar";
    hash = "sha256-JdrMsRmTT8U8RZDI2SnQxM5WGMpo1pL2CQ5BqLxcf5M=";
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
    description = "Tool for formatting Clojure code";
    homepage = "https://github.com/weavejester/cljfmt";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    changelog = "https://github.com/weavejester/cljfmt/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ sg-qwt ];
  };
}
