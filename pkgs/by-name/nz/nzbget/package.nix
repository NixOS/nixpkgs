{ lib
, stdenv
, fetchFromGitHub
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
  version = "24.3";

  src = fetchFromGitHub {
    owner = "nzbgetcom";
    repo = "nzbget";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Gci9bVjmewoEii6OiOuRpLgEBEKApmMmlA5v3OedCo4=";
  };

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
