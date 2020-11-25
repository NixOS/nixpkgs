{ stdenv, mkDerivation, fetchFromGitLab, fetchurl, pkg-config, qmake, qtx11extras, qttools, mpv }:

mkDerivation rec {
  pname = "mpc-qt";
  version = "2019-06-09";

  src = fetchFromGitLab {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "2abe6e7fc643068d50522468fe75d614861555ad";
    sha256 = "1cis8dl9pm91mpnp696zvwsfp96gkwr8jgs45anbwd7ldw78w4x5";
  };

  patches = [
    (fetchurl {
      url = "https://gitlab.com/mpc-qt/mpc-qt/-/commit/02f2bc7a22e863a89ba322b9acb61cf1aef23ba0.diff";
      sha256 = "15gcpcs54k09pndlpcfwb3fa0cg9fszyyb6vbp0hpgspy43183lx";
    })
  ];

  nativeBuildInputs = [ pkg-config qmake qttools ];

  buildInputs = [ mpv qtx11extras ];

  qmakeFlags = [ "QMAKE_LUPDATE=${qttools.dev}/bin/lupdate" ];

  meta = with stdenv.lib; {
    description = "Media Player Classic Qute Theater";
    homepage = "https://gitlab.com/mpc-qt/mpc-qt";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
