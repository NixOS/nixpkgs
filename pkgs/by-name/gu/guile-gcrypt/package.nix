{
  lib,
  autoreconfHook,
  fetchFromGitea,
  guile,
  libgcrypt,
  pkg-config,
  stdenv,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "guile-gcrypt";
  version = "0.4.0";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "cwebber";
    repo = "guile-gcrypt";
    rev = "v${version}";
    hash = "sha256-vbm31EsOJiMeTs2tu5KPXckxPcAQbi3/PGJ5EHCC5VQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    guile
    libgcrypt
    pkg-config
    texinfo
  ];

  buildInputs = [ guile ];

  propagatedBuildInputs = [ libgcrypt ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  doCheck = true;

  strictDeps = true;

  # In procedure bytevector-u8-ref: Argument 2 out of range
  dontStrip = stdenv.hostPlatform.isDarwin;

  meta = {
    homepage = "https://notabug.org/cwebber/guile-gcrypt";
    description = "Bindings to Libgcrypt for GNU Guile";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    inherit (guile.meta) platforms;
  };
}
