{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  fftw,
  ladspaH,
  libxml2,
  pkg-config,
  perlPackages,
}:

stdenv.mkDerivation rec {
  pname = "swh-plugins";
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "swh";
    repo = "ladspa";
    rev = "v${version}";
    sha256 = "sha256-eOtIhNcuItREUShI8JRlBVKfMfovpdfIYu+m37v4KLE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perlPackages.perl
    perlPackages.XMLParser
  ];
  buildInputs = [
    fftw
    ladspaH
    libxml2
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace util/Makefile.am --replace-fail "ranlib" "$RANLIB"
    substituteInPlace gsm/Makefile.am --replace-fail "ranlib" "$RANLIB"
    substituteInPlace gverb/Makefile.am --replace-fail "ranlib" "$RANLIB"
  '';

  meta = with lib; {
    homepage = "http://plugin.org.uk/";
    description = "LADSPA format audio plugins";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
