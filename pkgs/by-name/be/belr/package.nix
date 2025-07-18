{
  bctoolbox,
  cmake,
  fetchFromGitLab,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "belr";
  version = "5.3.72";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "belr";
    rev = finalAttrs.version;
    hash = "sha256-c8MYfMNRUSRvzZ+FtpKlP15MNeLCRPp7dsRCZhFs9QE=";
  };

  buildInputs = [ bctoolbox ];
  nativeBuildInputs = [ cmake ];

  # Do not build static libraries
  cmakeFlags = [ "-DENABLE_STATIC=NO" ];

  meta = with lib; {
    description = "Belledonne Communications' language recognition library. Part of the Linphone project";
    homepage = "https://gitlab.linphone.org/BC/public/belr";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ jluttine ];
  };
})
