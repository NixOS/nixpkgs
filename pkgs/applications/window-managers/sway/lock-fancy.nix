{ lib, stdenv, fetchFromGitHub, coreutils, grim, gawk, jq, swaylock
, imagemagick, getopt, fontconfig, wmctrl, makeWrapper
}:

let
  depsPath = lib.makeBinPath [
    coreutils
    grim
    gawk
    jq
    swaylock
    imagemagick
    getopt
    fontconfig
    wmctrl
  ];
in stdenv.mkDerivation rec {
  pname = "swaylock-fancy-unstable";
  version = "2021-10-11";

  src = fetchFromGitHub {
    owner = "Big-B";
    repo = "swaylock-fancy";
    rev = "265fbfb438392339bf676b0a9dbe294abe2a699e";
    sha256 = "NjxeJyWYXBb1P8sXKgb2EWjF+cNodTE83r1YwRYoBjM=";
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
