{
  lib,
  buildGraalvmNativeImage,
  graalvmPackages,
  fetchurl,
}:

buildGraalvmNativeImage rec {
  pname = "clj-kondo";
  version = "2025.02.20";

  src = fetchurl {
    url = "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-oTa/WA1ieukgHf8GX5oE1D2lTZ2KjFPty3aVWUb64Ck=";
  };

  graalvmDrv = graalvmPackages.graalvm-ce;

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
