{ stdenv, fetchFromGitHub, cmake, pkgconfig, gtk3, ncurses
, libcpuid, pciutils, procps, wrapGAppsHook, nasm, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "cpu-x";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "X0rg";
    repo = "CPU-X";
    rev = "v${version}";
    sha256 = "191zkkswlbbsw492yygc3idf7wh3bxs97drrqvqqw0mqvrzykxm3";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook nasm makeWrapper ];
  buildInputs = [
    gtk3 ncurses libcpuid pciutils procps
  ];

  postInstall = ''
    wrapProgram $out/bin/cpu-x \
      --prefix PATH : ${stdenv.lib.makeBinPath [ stdenv.cc ]}
  '';

  meta = with stdenv.lib; {
    description = "Free software that gathers information on CPU, motherboard and more";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ gnidorah ];
  };
}
