{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jemalloc,
  jre,
  runCommand,
  testers,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "besu";
  version = "24.1.2";

  src = fetchurl {
    url = "https://hyperledger.jfrog.io/artifactory/${pname}-binaries/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-CC24z0+2dSeqDddX5dJUs7SX9QJ8Iyh/nAp0pqdDvwg=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ jemalloc ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin $out/
    mkdir -p $out/lib
    cp -r lib $out/
    wrapProgram $out/bin/${pname} \
      --set JAVA_HOME "${jre}" \
      --suffix ${
        if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"
      } : ${lib.makeLibraryPath buildInputs}
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${version}";
    };
    jemalloc =
      runCommand "${pname}-test-jemalloc"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
          meta.platforms = with lib.platforms; linux;
        }
        ''
          # Expect to find this string in the output, ignore other failures.
          (besu 2>&1 || true) | grep -q "# jemalloc: ${jemalloc.version}"
          mkdir $out
        '';
  };

  meta = with lib; {
    description = "Enterprise-grade Java-based, Apache 2.0 licensed Ethereum client";
    homepage = "https://www.hyperledger.org/projects/besu";
    changelog = "https://github.com/hyperledger/besu/blob/${finalAttrs.version}/CHANGELOG.md";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    platforms = platforms.all;
    maintainers = with maintainers; [ mmahut ];
  };
})
