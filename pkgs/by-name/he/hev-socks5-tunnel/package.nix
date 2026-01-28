{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  name = "hev-socks5-tunnel";
  version = "2.14.3";

  src = fetchFromGitHub {
    owner = "heiher";
    repo = name;
    rev = "${version}";
    hash = "sha256-0Xcv9hfXOEwndEwy8K5TAQsCSStXkPZ0t7geNohKFGQ=";
    fetchSubmodules = true;
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin/
  '';

  meta = {
    description = "A simple, lightweight tunnel over Socks5 proxy (tun2socks)";
    homepage = "https://github.com/heiher/hev-socks5-tunnel";
    license = lib.licenses.mit;
    mainProgram = "hev-socks5-tunnel";
    platforms = lib.platforms.linux;
  };
}
