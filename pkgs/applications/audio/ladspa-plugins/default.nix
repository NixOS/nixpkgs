{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, automake
, fftw
, ladspaH
, libxml2
, pkg-config
, perlPackages
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

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fftw ladspaH libxml2 perlPackages.perl perlPackages.XMLParser ];

  patchPhase = ''
    patchShebangs .
    patchShebangs ./metadata/
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
