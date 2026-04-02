{
  stdenv,
  lib,
  fetchFromSourcehut,
  meson,
  ninja,
  pkg-config,
  wayland,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libscfg";
  version = "0.1.1";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "libscfg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aTcvs7QuDOx17U/yP37LhvIGxmm2WR/6qFYRtfjRN6w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ wayland ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://sr.ht/~emersion/libscfg";
    description = "Simple configuration file format";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ michaeladler ];
    platforms = lib.platforms.linux;
  };
})
