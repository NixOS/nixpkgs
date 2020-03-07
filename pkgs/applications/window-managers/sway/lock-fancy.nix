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
  version = "2020-02-22";

  src = fetchFromGitHub {
    owner = "Big-B";
    repo = "swaylock-fancy";
    rev = "5cf977b12f372740aa7b7e5a607d583f93f1e028";
    sha256 = "0laqwzi6069sgz91i69438ns0g2nq4zkqickavrf80h4g3gcs8vm";
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
