{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  gradle,
  jdk23,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "jextract";
  version = "unstable-2025-01-22";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "7ed79ecdf678db804f40b3494b6f1dafa760c808";
    hash = "sha256-GfMnCjP9t0B1xufAWAeVtcO26WPdmLDPB2b4dvRxEyk=";
  };

  nativeBuildInputs = [
    gradle
    makeBinaryWrapper
  ];

  gradleFlags = [
    "-Pllvm_home=${lib.getLib llvmPackages.libclang}"
    "-Pjdk_home=${jdk23}"
  ];

  doCheck = true;

  gradleCheckTask = "verify";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/
    cp -r ./build/jextract $out/opt/jextract
    makeBinaryWrapper "$out/opt/jextract/bin/jextract" "$out/bin/jextract"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool which mechanically generates Java bindings from a native library headers";
    mainProgram = "jextract";
    homepage = "https://github.com/openjdk/jextract";
    platforms = jdk23.meta.platforms;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      jlesquembre
      sharzy
    ];
  };
}
