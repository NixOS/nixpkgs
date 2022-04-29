{ autoreconfHook
, fetchFromGitHub
, glib
, intltool
, lib
, libappindicator-gtk2
, libtool
, pidgin
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "pidgin-indicator";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "philipl";
    repo = pname;
    rev = version;
    sha256 = "sha256-CdA/aUu+CmCRbVBKpJGydicqFQa/rEsLWS3MBKlH2/M=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ glib intltool libappindicator-gtk2 libtool pidgin ];

  meta = with lib; {
    description = "An AppIndicator and KStatusNotifierItem Plugin for Pidgin";
    homepage = "https://github.com/philipl/pidgin-indicator";
    maintainers = with maintainers; [ imalison ];
    license = licenses.gpl2;
    platforms = with platforms; linux;
  };
}
