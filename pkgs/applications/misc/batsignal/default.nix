{ stdenv, fetchFromGitHub, libnotify, pkg-config, glib }:

stdenv.mkDerivation rec {
  pname = "batsignal";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "electrickite";
    repo = "batsignal";
    rev = "${version}";
    sha256 = "0ss5dw7wpqsf96dig6r7x4fhf6brmjdy54jyyf5nk1h9kzw4d69r";
  };

  buildInputs = [ libnotify glib ];
  nativeBuildInputs = [ pkg-config ];
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/electrickite/batsignal";
    description = "Lightweight battery daemon written in C";
    license = licenses.isc;
    maintainers = with maintainers; [ SlothOfAnarchy ];
    platforms = platforms.linux;
  };
}
