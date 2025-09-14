{
  cmake,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "bcunit";
  version = "linphone-4.4.1";

  nativeBuildInputs = [ cmake ];
  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "bcunit";
    rev = "c5eebcc7f794e9567d3c72d15d3f28bffe6bfd0f";
    sha256 = "sha256-8DSfqHerx/V00SJjTSQaG9Rjqx330iG6sGivBDUvQfA=";
  };

  meta = {
    description = "Belledonne Communications' fork of CUnit test framework. Part of the Linphone project";
    homepage = "https://gitlab.linphone.org/BC/public/bcunit";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      raskin
      jluttine
    ];
    platforms = lib.platforms.all;
  };
}
