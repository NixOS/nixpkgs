{ stdenv, fetchpatch, fetchFromGitHub, qmake, pkgconfig
, qtbase, qtsvg, qtserialport, boost, libgit2
}:

stdenv.mkDerivation rec {
  name = "fritzing-${version}";
  version = "0.9.3b";

  src = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-app";
    rev = version;
    sha256 = "0hpyc550xfhr6gmnc85nq60w00rm0ljm0y744dp0z88ikl04f4s3";
  };

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    rev = version;
    sha256 = "1d2v8k7p176j0lczx4vx9n9gbg3vw09n2c4b6w0wj5wqmifywhc1";
  };

  patches = [(fetchpatch {
    name = "0001-Squashed-commit-of-the-following.patch";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-Squashed-commit-of-the-following.patch?h=fritzing";
    sha256 = "1cv6myidxhy28i8m8v13ghzkvx5978p9dcd8v7885y0l1h3108mf";
  })];

  buildInputs = [ qtbase qtsvg qtserialport boost libgit2 ];

  nativeBuildInputs = [ qmake pkgconfig ];

  qmakeFlags = [ "phoenix.pro" ];

  preConfigure = ''
    ln -s "$parts" parts
  '';

  meta = {
    description = "An open source prototyping tool for Arduino-based projects";
    homepage = http://fritzing.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.robberer ];
    platforms = stdenv.lib.platforms.linux;
  };
}
