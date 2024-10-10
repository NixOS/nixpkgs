{
  stdenv,
  lib,
  fetchurl,
}:

let
  rev = "041c6f26162c2286776fac246ddbda312da1563d";
in
stdenv.mkDerivation {
  pname = "dut";
  version = "0-unstable-2024-07-31";

  src = fetchurl {
    url = "https://codeberg.org/201984/dut/archive/${rev}.tar.gz";
    sha256 = "sha256-4OAZfoftRNWXxm0vGlJOjNxUMvFzUKbfW0fYT2ne6Bk=";
  };

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = {
    description = "A disk usage calculator for Linux";
    homepage = "https://codeberg.org/201984/dut";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "dut";
  };
}
