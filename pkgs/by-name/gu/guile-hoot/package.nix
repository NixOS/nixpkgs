{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-hoot";
  version = "0.6.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "spritely";
    repo = "hoot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y3UWKSjJQnYh+06p+Oi0Fa0ul2T8QWemgNm9A0su5WQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
  ];
  strictDeps = true;

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scheme to WebAssembly compiler backend for GNU Guile and a general purpose WASM toolchain";
    homepage = "https://codeberg.org/spritely/hoot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
    platforms = lib.platforms.unix;
  };
})
