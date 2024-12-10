{
  lib,
  buildGraalvmNativeImage,
  graalvmCEPackages,
  fetchurl,
}:

buildGraalvmNativeImage rec {
  pname = "clj-kondo";
  version = "2024.09.27";

  src = fetchurl {
    url = "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-DrSfL1WazlNd5H0jG6m0S5aED4BLVufr1rGIAyifn6E=";
  };

  graalvmDrv = graalvmCEPackages.graalvm-ce;

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
  ];

  meta = with lib; {
    description = "Linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl10;
    changelog = "https://github.com/clj-kondo/clj-kondo/blob/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [
      jlesquembre
      bandresen
    ];
  };
}
