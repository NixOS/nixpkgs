{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  ronn,
}:

stdenv.mkDerivation rec {
  pname = "automirror";
  version = "49";

  src = fetchFromGitHub {
    owner = "schlomo";
    repo = "automirror";
    rev = "v${version}";
    hash = "sha256-kGmKIZi67a2BU8qrZgZ490CAHlP1XRYG98uhytpx3us=";
  };

  patchPhase = "sed -i s#/usr##g Makefile";

  buildInputs = [
    git
    ronn
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/schlomo/automirror";
    description = "Automatic Display Mirror";
    license = licenses.gpl3;
    platforms = platforms.all;
    mainProgram = "automirror";
  };
}
