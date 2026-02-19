{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  zlib,
  kssd,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kssd";
  version = "2.21-unstable-2024-05-27";

  src = fetchFromGitHub {
    owner = "yhg926";
    repo = "public_kssd";
    rev = "ce96b66dddc2d6c1ce611ad84cdf4c7ba62b4aa5";
    hash = "sha256-qafPyDl+pDfnJ7S6mHBHht2OcQEQeV2kQM+ir5LTGFA=";
  };

  patches = [
    # https://github.com/yhg926/public_kssd/pull/11
    (fetchpatch {
      name = "allocate-enough-memory.patch";
      url = "https://github.com/yhg926/public_kssd/commit/b1e66bbcc04687bc3201301cd742a0b26a87cb5d.patch";
      hash = "sha256-yFyJetpsGKeu+H6Oxrmn5ea4ESVtblb3YJDja4JEAEM=";
    })
  ];

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall

    install -vD kssd $out/bin/kssd

    runHook postInstall
  '';

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
      mkdir $out
      ${lib.getExe kssd} dist -L ${kssd.src}/shuf_file/L3K10.shuf -r ${kssd.src}/test_fna/seqs1 -o $out/reference
      ${lib.getExe kssd} dist -L ${kssd.src}/shuf_file/L3K10.shuf -o $out/query ${kssd.src}/test_fna/seqs2
      ${lib.getExe kssd} dist -r $out/reference -o $out/distout $out/query
    '';
  };

  meta = {
    description = "K-mer substring space decomposition";
    license = lib.licenses.asl20;
    homepage = "https://github.com/yhg926/public_kssd";
    maintainers = with lib.maintainers; [ unode ];
    platforms = lib.platforms.linux;
    mainProgram = "kssd";
  };
})
