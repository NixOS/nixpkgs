{
  lib,
  python3,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
}:

let
  python = python3.withPackages (
    pp: with pp; [
      certifi
      charset-normalizer
      idna
      prometheus-client
      requests
      six
      urllib3
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "mailman3-exporter";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "rivimey";
    repo = "mailman3_exporter";
    tag = version;
    hash = "sha256-IupfZ3/MXBYpIyH8kJRc+WYabzSZyIu1WDITKTB5+Zc=";
  };

  patches = [
    # https://github.com/rivimey/mailman3_exporter/pull/3
    (fetchpatch2 {
      url = "https://github.com/MarcelCoding/mailman3_exporter/commit/65070106451c6aafe8956387111343e490e34df8.patch?full_index=1";
      hash = "sha256-2XM0ktLC4+7/PEgeToVR84Gfjx1UKxl/+jo6JGnVZMw=";
    })
    # https://github.com/rivimey/mailman3_exporter/pull/4
    (fetchpatch2 {
      url = "https://github.com/MarcelCoding/mailman3_exporter/commit/a7850a1e9ce65f91683eef67eb1c6537c2c2eb77.patch?full_index=1";
      hash = "sha256-bBIin/7Y1bWrvxCuw1kJG8gaoKjkKdQnxfqpRipvyFs=";
    })
  ];

  buildInputs = [
    python
  ];

  installPhase = ''
    install -D mailman_exporter.py $out/bin/mailman3_exporter
  '';

  meta = {
    description = "Mailman3 Exporter for Prometheus";
    homepage = "https://github.com/rivimey/mailman3_exporter";
    # no license in repo
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ marcel ];
    mainProgram = "mailman3_exporter";
    platforms = lib.platforms.all;
  };
}
