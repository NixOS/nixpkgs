{
  lib,
  stdenv,
  fetchFromGitHub,
  simde,
  zlib,
  enableSse4_1 ? stdenv.hostPlatform.sse4_1Support,
  enableAvx ? stdenv.hostPlatform.avxSupport,
  enablePython ? false,
  python3Packages,
  runCommand,
  abpoa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "${lib.optionalString enablePython "py"}abpoa";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "yangao07";
    repo = "abPOA";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E6XdiRULgJy9rf4NfXGBqUC+m0pMZKMsA5pHvCNNLJk=";
  };

  patches = [ ./simd-arch.patch ];

  postPatch = ''
    cp -r ${simde.src}/* include/simde
    substituteInPlace Makefile \
      --replace-fail "-march=native" ""
  '';

  nativeBuildInputs = lib.optionals enablePython (
    with python3Packages;
    [
      cython_0
      pypaBuildHook
      pypaInstallHook
      pythonImportsCheckHook
      setuptools
    ]
  );

  buildFlags = lib.optionals stdenv.hostPlatform.isx86_64 [
    (
      if enableAvx then
        "avx2=1"
      else if enableSse4_1 then
        "sse41=1"
      else
        "sse2=1"
    )
  ];

  env = lib.optionalAttrs enablePython (
    if enableAvx then
      { "AVX2" = 1; }
    else if enableSse4_1 then
      { "SSE41" = 1; }
    else
      { "SSE2" = 1; }
  );

  buildInputs = [ zlib ];

  installPhase = lib.optionalString (!enablePython) ''
    runHook preInstall

    install -Dm755 ./bin/abpoa* $out/bin/abpoa

    runHook postInstall
  '';

  pythonImportsCheck = [ "pyabpoa" ];

  doInstallCheck = enablePython;

  installCheckPhase = ''
    runHook preInstallCheck

    python python/example.py

    runHook postInstallCheck
  '';

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
      ${lib.getExe abpoa} ${abpoa.src}/test_data/seq.fa > $out
    '';
  };

  meta = {
    description = "SIMD-based C library for fast partial order alignment using adaptive band";
    homepage = "https://github.com/yangao07/abPOA";
    changelog = "https://github.com/yangao07/abPOA/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "abpoa";
    platforms = lib.platforms.unix;
  };
})
