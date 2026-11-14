{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "pcimem";
  version = "0-unstable-2018-08-29";

  src = fetchFromGitHub {
    owner = "billfarrow";
    repo = "pcimem";
    rev = "09724edb1783a98da2b7ae53c5aaa87493aabc9b";
    hash = "sha256-A69p0DuptFOFMpCmox6yD6Mb+gWAjxuCsg8SXCjbi34=";
  };

  outputs = [
    "out"
    "doc"
  ];

  makeFlags = [ "CFLAGS=-Wno-maybe-uninitialized" ];

  installPhase = ''
    install -D pcimem "$out/bin/pcimem"
    install -D README "$doc/doc/README"
  '';

  meta = {
    description = "Simple method of reading and writing to memory registers on a PCI card";
    mainProgram = "pcimem";
    homepage = "https://github.com/billfarrow/pcimem";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mafo ];
  };
}
