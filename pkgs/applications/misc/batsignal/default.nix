{ lib, stdenv, fetchFromGitHub, libnotify, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "batsignal";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "electrickite";
    repo = "batsignal";
    rev = version;
    sha256 = "sha256-uDfC/PqT1Bb8np0l2DDIZUoNP9QpjxZH5v1hK2k1Miw=";
  };

  buildInputs = [ libnotify glib ];
  nativeBuildInputs = [ pkg-config ];
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/electrickite/batsignal";
    description = "Lightweight battery daemon written in C";
    license = licenses.isc;
    maintainers = with maintainers; [ SlothOfAnarchy ];
    platforms = platforms.linux;
  };
}
