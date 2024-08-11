{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, boost
, pkg-config
, gnutls
, libgcrypt
, libpar2
, libcap
, libsigcxx
, libxml2
, ncurses
, openssl
, zlib
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nzbget";
  version = "24.1";

  src = fetchFromGitHub {
    owner = "nzbgetcom";
    repo = "nzbget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HovfnTsgu07/lp/spI+iA8H7lOj0Qyrri2MOJKyMKHQ=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    boost
    gnutls
    libgcrypt
    libpar2
    libcap
    libsigcxx
    libxml2
    ncurses
    openssl
    zlib
  ];

  prePatch = ''
    sed -i 's/AC_INIT.*/AC_INIT( nzbget, m4_esyscmd_s( echo ${finalAttrs.version} ) )/' configure.ac
  '';

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) nzbget; };

  meta = with lib; {
    homepage = "https://nzbget.com/";
    changelog = "https://github.com/nzbgetcom/nzbget/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2Plus;
    description = "Command line tool for downloading files from news servers";
    maintainers = with maintainers; [ pSub devusb ];
    platforms = with platforms; unix;
    mainProgram = "nzbget";
  };
})
