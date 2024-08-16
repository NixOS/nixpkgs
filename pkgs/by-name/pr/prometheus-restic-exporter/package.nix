{ lib
, stdenvNoCC
, fetchFromGitHub
, python3
, restic
, nixosTests
}:

stdenvNoCC.mkDerivation rec {
  pname = "prometheus-restic-exporter";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ngosang";
    repo = "restic-exporter";
    rev = version;
    hash = "sha256-gXiEts0EY9H01+rs+2o+cbVENotM33uhcQiGDtroSU4=";
  };

  buildInputs = [
    (python3.withPackages (ps: [ ps.prometheus-client ]))
  ];

  installPhase = ''
    runHook preInstall

    install -D -m0755 restic-exporter.py $out/bin/restic-exporter.py

    substituteInPlace $out/bin/restic-exporter.py --replace-fail \"restic\" \"${lib.makeBinPath [ restic ]}/restic\"

    patchShebangs $out/bin/restic-exporter.py

    runHook postInstall
  '';

  passthru.tests = {
    restic-exporter = nixosTests.prometheus-exporters.restic;
  };

  meta = with lib; {
    description = "Prometheus exporter for the Restic backup system";
    homepage = "https://github.com/ngosang/restic-exporter";
    changelog = "https://github.com/ngosang/restic-exporter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ minersebas ];
    mainProgram = "restic-exporter.py";
    platforms = platforms.all;
  };
}
