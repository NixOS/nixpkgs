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
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "swig";
    repo = "swig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jsi83v9sg0n5kUfDACqdNAS2VuLSyxv+pe2LRcO4Khc=";
  };

  # It is necessary to pull in the target pcre2-config binary this way because including pcre2 in nativeBuildInputs can create linking failures with cross-compilation
  env.PCRE2_CONFIG = "${pcre2.dev}/bin/pcre2-config";
  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    libtool
    bison
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

  enableParallelBuilding = true;

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/swig/swig/blob/${finalAttrs.src.rev}/CHANGES.current";
    description = "Interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    # Different types of licenses available: https://www.swig.org/Release/LICENSE .
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "swig";
    platforms = with lib.platforms; linux ++ darwin;
  };
})
