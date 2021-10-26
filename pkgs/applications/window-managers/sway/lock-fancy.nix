{ lib, stdenv, fetchFromGitHub, coreutils, grim, gawk, swaylock
, imagemagick, getopt, fontconfig, makeWrapper
}:

let
  depsPath = lib.makeBinPath [
    coreutils
    grim
    gawk
    swaylock
    imagemagick
    getopt
    fontconfig
  ];
in stdenv.mkDerivation rec {
  pname = "swaylock-fancy-unstable";
  version = "2021-10-11";

  src = fetchFromGitHub {
    owner = "Big-B";
    repo = "swaylock-fancy";
    rev = "265fbfb438392339bf676b0a9dbe294abe2a699e";
    sha256 = "0cq650bc2n5xvqy32xb8qgwwas0iyq32l5yb7zsicp4q4lkmwg1n";
  };

  postPatch = ''
    substituteInPlace swaylock-fancy \
      --replace "/usr/share" "$out/share"
  '';

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/swaylock-fancy \
      --prefix PATH : "${depsPath}"
  '';

  meta = with lib; {
    description = "This is an swaylock bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text";
    homepage = "https://github.com/Big-B/swaylock-fancy";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
