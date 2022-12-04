{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtk3
, pcre
, pkg-config
, vte
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "kermit";
  version = "3.8";

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "orhun";
    repo = pname;
    rev = version;
    hash = "sha256-XPHF33Nu+H8OcQFwsuUOhDBDWKm8sh5B36sfROeSWPg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gtk3
    pcre
    vte
  ];

  passthru.tests.test = nixosTests.terminal-emulators.kermit;

  meta = with lib; {
    homepage = "https://github.com/orhun/kermit";
    description = "A VTE-based, simple and froggy terminal emulator";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
