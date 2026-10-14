{
  lib,
  fetchgit,
  automake,
  autoconf,
  libtool,
  libedit,
  tcl,
  tk,
}:

tcl.mkTclDerivation (finalAttrs: {
  pname = "eltclsh";
  version = "1.20";

  src = fetchgit {
    url = "https://git.openrobots.org/robots/eltclsh.git";
    tag = "eltclsh-${finalAttrs.version}";
    hash = "sha256-kNUT190DkY+NNUmBwHfSxgBLbSyc0MutVDLsRh7kFDE=";
  };

  nativeBuildInputs = [
    automake
    autoconf
    libtool
  ];
  buildInputs = [
    libedit
    tk
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--enable-tclshrl"
    "--enable-wishrl"
    "--with-tk=${tk}/lib"
    "--with-includes=${libedit.dev}/include/readline"
    "--with-libtool=${libtool}"
  ];

  meta = {
    description = "Interactive shell for the TCL programming language based on editline";
    homepage = "https://homepages.laas.fr/mallet/soft/shell/eltclsh";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iwanb ];
    platforms = lib.platforms.all;
  };
})
