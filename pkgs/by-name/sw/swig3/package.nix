{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  bison,
  pcre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swig";
  version = "3.0.12";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "rel-${finalAttrs.version}";
    sha256 = "1wyffskbkzj5zyhjnnpip80xzsjcr3p0q5486z3wdwabnysnhn8n";
  };

  # Not using autoreconfHook because it fails due to missing macros, contrary
  # to this script
  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    bison
  ];
  buildInputs = [
    pcre
  ];

  configureFlags = [
    "--without-tcl"
  ];

  # Disable ccache documentation as it needs yodl
  postPatch = ''
    sed -i '/man1/d' CCache/Makefile.in
  '';

  meta = {
    description = "Interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    # Different types of licenses available: http://www.swig.org/Release/LICENSE .
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
