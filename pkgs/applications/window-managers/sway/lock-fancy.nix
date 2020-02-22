{ stdenv, fetchFromGitHub, coreutils, grim, gawk, swaylock
, imagemagick, getopt, fontconfig, makeWrapper
}:

let
  depsPath = stdenv.lib.makeBinPath [
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
  version = "2019-03-31";

  src = fetchFromGitHub {
    owner = "Big-B";
    repo = "swaylock-fancy";
    rev = "35618ceec70338047355b6b057825e68f16971b5";
    sha256 = "06fjqwblmj0d9pq6y11rr73mizirna4ixy6xkvblf1c7sn5n8lpc";
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

  meta = with stdenv.lib; {
    description = "This is an swaylock bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text";
    homepage = "https://github.com/Big-B/swaylock-fancy";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
