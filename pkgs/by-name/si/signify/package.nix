{
  lib,
  stdenv,
  fetchFromCodeberg,
  libbsd,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "signify";
  version = "33";

  src = fetchFromCodeberg {
    owner = "aperezdc";
    repo = "signify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cBeCnhLwhRnIVa/naNl5AysSg5RncnOtQpmTHNicHAo=";
  };

  doCheck = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libbsd ];

  postPatch = ''
    substituteInPlace Makefile --replace "shell pkg-config" "shell $PKG_CONFIG"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "OpenBSD signing tool";
    mainProgram = "signify";
    longDescription = ''
      OpenBSDs signing tool, which uses the Ed25519 public key signature system
      for fast signing and verification of messages using small public keys.
    '';
    homepage = "https://codeberg.org/aperezdc/signify";
    changelog = "https://codeberg.org/aperezdc/signify/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.rlupton20 ];
    platforms = lib.platforms.linux;
  };
})
