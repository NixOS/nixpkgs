{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pidgin,
  minixml,
  libxml2,
  sqlite,
  libgcrypt,
}:

stdenv.mkDerivation rec {
  pname = "purple-lurch";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "gkdr";
    repo = "lurch";
    rev = "v${version}";
    hash = "sha256-yyzotKL1Z4B2BxloJndJKemONMPLG9pVDVe2K5AL05g=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    pidgin
    minixml
    libxml2
    sqlite
    libgcrypt
  ];

  dontUseCmakeConfigure = true;

  installPhase = ''
    install -Dm755 -t $out/lib/purple-2 build/lurch.so
  '';

  meta = with lib; {
    homepage = "https://github.com/gkdr/lurch";
    description = "XEP-0384: OMEMO Encryption for libpurple";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ emmanuelrosa ];
  };
}
