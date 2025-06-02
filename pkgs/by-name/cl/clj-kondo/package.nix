{
  lib,
  buildGraalvmNativeImage,
  graalvmPackages,
  fetchurl,
}:

buildGraalvmNativeImage rec {
  pname = "clj-kondo";
  version = "2025.04.07";

  src = fetchurl {
    url = "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-yJyRqQglJUiHotB70zga5NhFquHsKgmwT9sryZHEFRU=";
  };

  graalvmDrv = graalvmPackages.graalvm-ce;

  extraNativeImageBuildArgs = [
    "-H:+ReportExceptionStackTraces"
    "--no-fallback"
  ];

  meta = {
    description = "Linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    changelog = "https://github.com/clj-kondo/clj-kondo/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      jlesquembre
      bandresen
    ];
  };
}
