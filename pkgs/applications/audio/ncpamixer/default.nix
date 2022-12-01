{ lib, stdenv, fetchFromGitHub, cmake, ncurses, libpulseaudio, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ncpamixer";
  version = "unstable-2021-10-17";

  src = fetchFromGitHub {
    owner = "fulhax";
    repo = "ncpamixer";
    rev = "4faf8c27d4de55ddc244f372cbf5b2319d0634f7";
    sha256 = "sha256-ElbxdAaXAY0pj0oo2IcxGT+K+7M5XdCgom0XbJ9BxW4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ ncurses libpulseaudio ];

  configurePhase = ''
    make PREFIX=$out USE_WIDE=1 RELEASE=1 build/Makefile
  '';

  meta = with lib; {
    description = "An ncurses mixer for PulseAudio inspired by pavucontrol";
    homepage = "https://github.com/fulhax/ncpamixer";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ StijnDW ] ++ teams.c3d2.members;
  };
}
