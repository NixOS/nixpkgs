{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "signify";
  version = "32";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "signify";
    rev = "v${version}";
    sha256 = "sha256-y2A+Szt451CmaWOc2Y2vBSwSgziJsSnTjNClbdyxG2U=";
  };

  doCheck = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libbsd ];

  postPatch = ''
    substituteInPlace Makefile --replace "shell pkg-config" "shell $PKG_CONFIG"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "OpenBSD signing tool";
    mainProgram = "signify";
    longDescription = ''
      OpenBSDs signing tool, which uses the Ed25519 public key signature system
      for fast signing and verification of messages using small public keys.
    '';
    homepage = "https://www.tedunangst.com/flak/post/signify";
    license = licenses.isc;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux;
  };
}
