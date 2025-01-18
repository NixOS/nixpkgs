{
  lib,
  stdenv,
  fetchFromGitHub,
  diffutils,
  gd,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "s2png";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "s2png";
    rev = "v${version}";
    sha256 = "0y3crfm0jqprgxamlly713cka2x1bp6z63p1lw9wh4wc37kpira6";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    diffutils
    gd
  ];
  installFlags = [
    "prefix="
    "DESTDIR=$(out)"
  ];

  meta = with lib; {
    homepage = "https://github.com/dbohdan/s2png/";
    description = "Store any data in PNG images";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.dbohdan ];
    platforms = platforms.unix;
    mainProgram = "s2png";
  };
}
