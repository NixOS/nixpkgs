{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  bison,
  pcre2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swig";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hFHEE9wy8Lja9G396tI4fj4LhOkpPKJkDuy1L62AXr4=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    libtool
    bison
    pcre2
  ];
  buildInputs = [ pcre2 ];

  configureFlags = [ "--without-tcl" ];

  # Disable ccache documentation as it needs yodl
  postPatch = ''
    sed -i '/man1/d' CCache/Makefile.in
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    changelog = "https://github.com/swig/swig/blob/${finalAttrs.src.rev}/CHANGES.current";
    description = "Interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    # Different types of licenses available: https://www.swig.org/Release/LICENSE .
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ orivej ];
    mainProgram = "swig";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
