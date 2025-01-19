{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "pacvim";
  version = "2018-05-16";
  src = fetchFromGitHub {
    owner = "jmoon018";
    repo = "PacVim";
    rev = "ca7c8833c22c5fe97974ba5247ef1fcc00cedb8e";
    sha256 = "1kq6j7xmsl5qfl1246lyglkb2rs9mnb2rhsdrp18965dpbj2mhx2";
  };
  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #   https://github.com/jmoon018/PacVim/pull/53
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/jmoon018/PacVim/commit/760682824cdbb328af616ff43bf822ade23924f7.patch";
      sha256 = "1y3928dc2nkfldqhpiqk0blbx7qj8ar35f1w7fb92qwxrj8p4i6g";
    })
  ];

  buildInputs = [ ncurses ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/jmoon018/PacVim";
    description = "Game that teaches you vim commands";
    mainProgram = "pacvim";
    maintainers = [ ];
    license = licenses.lgpl3;
    platforms = platforms.unix;
  };
}
