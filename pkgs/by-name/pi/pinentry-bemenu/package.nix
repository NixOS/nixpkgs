{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, libassuan
, libgpg-error, popt, bemenu }:

stdenv.mkDerivation rec {
  pname = "pinentry-bemenu";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "t-8ch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kiGUCcQIS58XjE4r0yiK4hJ85Sg5wrtBqeSYcgUKAmo=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libassuan libgpg-error popt bemenu ];

  meta = with lib; {
    description = "Pinentry implementation based on bemenu";
    homepage = "https://github.com/t-8ch/pinentry-bemenu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jc ];
    platforms = with platforms; linux;
    mainProgram = "pinentry-bemenu";
  };
}
