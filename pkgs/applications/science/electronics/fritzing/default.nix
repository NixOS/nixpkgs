{ mkDerivation, stdenv, fetchpatch, fetchFromGitHub, qmake, pkgconfig
, qtbase, qtsvg, qtserialport, boost, libgit2
}:

mkDerivation rec {
  pname = "fritzing";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-app";
    rev = "CD-498";
    sha256 = "0aljj2wbmm1vd64nhj6lh9qy856pd5avlgydsznya2vylyz20p34";
  };

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    rev = "97dfd491bec4355d946792a27a59a199b9abbd8b";
    sha256 = "0n1i1zp8n96w1jk2xh4y5mw518718fk12nzlwqa2j9ll98q1g40c";
  };

  patches = [
    (fetchpatch {
      name = "0001-fix-libgit2-version-check.patch";
      url = "https://github.com/fritzing/fritzing-app/commit/472951243d70eeb40a53b1f7e16e6eab0588d079.patch";
      sha256 = "0v1zi609cjnqac80xgnk23n54z08g1lia37hbzfl8jcq9sn9adak";
    })
    ./0002-libgit-dynamic.patch
  ];

  buildInputs = [ qtbase qtsvg qtserialport boost libgit2 ];

  nativeBuildInputs = [ qmake pkgconfig ];

  qmakeFlags = [ "phoenix.pro" ];

  preConfigure = ''
    ln -s "$parts" parts
  '';

  meta = {
    description = "An open source prototyping tool for Arduino-based projects";
    homepage = "http://fritzing.org/";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.robberer ];
    platforms = stdenv.lib.platforms.linux;
  };
}
