{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  automake,
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

  preBuild = ''
    shopt -s globstar
    for f in **/Makefile; do
      substituteInPlace "$f" \
        --replace-quiet 'ranlib' '${stdenv.cc.targetPrefix}ranlib'
    done
    shopt -u globstar
  '';

  nativeBuildInputs = [
    autoreconfHook
    perlPackages.perl
    perlPackages.XMLParser
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
    patchShebangs --build . ./metadata/ makestub.pl
    cp ${automake}/share/automake-*/mkinstalldirs .
  '';

  meta = with lib; {
    homepage = "http://plugin.org.uk/";
    description = "LADSPA format audio plugins";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
