{
  lib,
  stdenv,
  fetchFromGitHub,
  guile,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scheme-bytestructures";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "TaylanUB";
    repo = "scheme-bytestructures";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-7FK1dXD1Qz6fFYjNUtHMaDGaezHLVaDvdgOboNNw0Lc=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
  ];
  buildInputs = [
    guile
  ];

  doCheck = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  # In procedure bytevector-u8-ref: Argument 2 out of range
  dontStrip = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Structured access to bytevector contents";
    homepage = "https://github.com/TaylanUB/scheme-bytestructures";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
  };
})
