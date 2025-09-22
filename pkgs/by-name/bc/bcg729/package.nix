{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "bcg729";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "bcg729";
    rev = version;
    sha256 = "1hal6b3w6f8y5r1wa0xzj8sj2jjndypaxyw62q50p63garp2h739";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '\$'{exec_prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR}
  '';

  meta = {
    description = "Opensource implementation of both encoder and decoder of the ITU G729 Annex A/B speech codec";
    homepage = "https://linphone.org/technical-corner/bcg729";
    changelog = "https://gitlab.linphone.org/BC/public/bcg729/raw/${version}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ c0bw3b ];
    platforms = lib.platforms.all;
  };
}
