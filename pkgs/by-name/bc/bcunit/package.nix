{
  cmake,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcunit";
  version = "5.3.79";

  nativeBuildInputs = [ cmake ];
  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "bcunit";
    rev = finalAttrs.version;
    sha256 = "sha256-awfkUvhJAfX5Ls93V5ttU/2AyEp3Ze3KBWc4Kldi82Y=";
  };

  meta = with lib; {
    description = "Belledonne Communications' fork of CUnit test framework. Part of the Linphone project";
    homepage = "https://gitlab.linphone.org/BC/public/bcunit";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [
      raskin
      jluttine
    ];
    platforms = platforms.all;
  };
})
