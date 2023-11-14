{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, zlib
, kssd
, runCommand
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kssd";
  version = "2.21";

  src = fetchFromGitHub {
    owner = "yhg926";
    repo = "public_kssd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-D/s1jL2oKE0rSdRMVljskYFsw5UPOv1L95Of+K+e17w=";
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

  meta = with lib; {
    description = "K-mer substring space decomposition";
    license     = licenses.asl20;
    homepage    = "https://github.com/yhg926/public_kssd";
    maintainers = with maintainers; [ unode ];
    platforms = platforms.linux;
    mainProgram = "kssd";
  };
})
