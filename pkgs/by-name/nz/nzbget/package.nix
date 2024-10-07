{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
, cmake
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
, deterministic-uname
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nzbget";
  version = "24.2";

  src = fetchFromGitHub {
    owner = "nzbgetcom";
    repo = "nzbget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+iJ5n/meBrMxKHSLxL5QJ7+TI0RMfAM5n/8dwYupGoU=";
  };

  patches = [
    (fetchpatch2 {
      # status page buffer overflow fix: https://github.com/nzbgetcom/nzbget/pull/346 -- remove when version > 24.2
      url = "https://github.com/nzbgetcom/nzbget/commit/f89978f7479cbb0ff2f96c8632d9d2f31834e6c8.patch";
      hash = "sha256-9K7PGzmoZ8cvEKBm5htfw5fr1GBSddNkDC/Vi4ngRto=";
    })
  ];

  nativeBuildInputs = [ cmake pkg-config ];

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

  postPatch = ''
    substituteInPlace daemon/util/Util.cpp \
      --replace-fail "std::string(\"uname \")" "std::string(\"${lib.getExe deterministic-uname} \")"
  '';

  postInstall = ''
    install -Dm444 nzbget.conf $out/share/nzbget/nzbget.conf
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
