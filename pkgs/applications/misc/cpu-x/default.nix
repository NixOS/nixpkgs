{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, gtk3, ncurses
, libcpuid, pciutils, procps, wrapGAppsHook, nasm, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "cpu-x";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "X0rg";
    repo = "CPU-X";
    rev = "v${version}";
    sha256 = "sha256-9oRNyspFmvIG63aJ8qyaVmi1GW1eW+Rg0+z8la3LuKA=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook nasm makeWrapper ];
  buildInputs = [
    gtk3 ncurses libcpuid pciutils procps
  ];

  postInstall = ''
    wrapProgram $out/bin/cpu-x \
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
  '';

  meta = with lib; {
    description = "Free software that gathers information on CPU, motherboard and more";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
