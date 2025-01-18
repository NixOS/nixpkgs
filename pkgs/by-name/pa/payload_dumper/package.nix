{
  lib,
  stdenv,
  makeWrapper,
  python3,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "payload_dumper";
  version = "unstable-2022-04-11";

  src = fetchFromGitHub {
    owner = "vm03";
    repo = "payload_dumper";
    rev = "c1eb5dbbc7bd88ac94635ae90ec22ccf92f89881";
    sha256 = "1j1hbh5vqq33wq2b9gqvm1qs9nl0bmqklbnyyyhwkcha7zxn0aki";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with python3.pkgs; [
    bsdiff4
    protobuf
  ];

  installPhase = ''
    runHook preInstall

    sitePackages=$out/${python3.sitePackages}/${finalAttrs.pname}

    install -D ./payload_dumper.py $out/bin/payload_dumper
    install -D ./update_metadata_pb2.py $sitePackages/update_metadata_pb2.py

    wrapProgram $out/bin/payload_dumper \
        --set PYTHONPATH "$sitePackages:$PYTHONPATH"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = finalAttrs.src.meta.homepage;
    description = "Android OTA payload dumper";
    license = licenses.gpl3;
    maintainers = with maintainers; [ DamienCassou ];
    mainProgram = "payload_dumper";
  };
})
