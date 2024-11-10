{ cmake
, fetchFromGitLab
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "bcunit";
  version = "linphone-4.4.1";

  nativeBuildInputs = [ cmake ];
  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = pname;
    rev = "c5eebcc7f794e9567d3c72d15d3f28bffe6bfd0f";
    sha256 = "sha256-8DSfqHerx/V00SJjTSQaG9Rjqx330iG6sGivBDUvQfA=";
  };

  meta = with lib; {
    description = "Belledonne Communications' fork of CUnit test framework. Part of the Linphone project";
    homepage = "https://gitlab.linphone.org/BC/public/bcunit";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin jluttine ];
    platforms = platforms.all;
  };
}
