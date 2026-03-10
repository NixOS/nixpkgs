{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-hoot";
  version = "0.8.0";

  src = fetchFromCodeberg {
    owner = "spritely";
    repo = "hoot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b372dMUsDTa+hYrOwvj+/YcwVP52BCJxwSGRaqSSWZs=";
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
