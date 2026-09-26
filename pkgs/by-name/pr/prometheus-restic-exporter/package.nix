{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  restic,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "prometheus-restic-exporter";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ngosang";
    repo = "restic-exporter";
    rev = version;
    hash = "sha256-b3TbBZqNJEAveNVf+6OGHU2G3UUyuSEjzFMPJVuxlBE=";
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

  meta = {
    description = "Prometheus exporter for the Restic backup system";
    homepage = "https://github.com/ngosang/restic-exporter";
    changelog = "https://github.com/ngosang/restic-exporter/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minersebas ];
    mainProgram = "restic-exporter.py";
    platforms = lib.platforms.all;
  };
}
