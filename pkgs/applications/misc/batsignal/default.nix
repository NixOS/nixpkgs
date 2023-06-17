{ lib, stdenv, fetchFromGitHub, libnotify, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "batsignal";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "electrickite";
    repo = "batsignal";
    rev = version;
    sha256 = "sha256-Z5j5tSIF3AZiZjkFFtyyi3hMqWMXtf6ont2CQ/FSEjk=";
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
