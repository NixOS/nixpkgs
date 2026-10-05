{
  acl,
  fetchFromCodeberg,
  lib,
  libcap,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "seedfiles";
  version = "1.7.2";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "Gardenhouse";
    repo = "seedfiles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bnawN7sbRrQ7Tb4QbPd7DgKEvgGefy8jyg3fsH4X914=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ acl ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libcap ];

  mesonFlags = [
    "-Ddefault_configs=disabled"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Portable drop-in reimplementation of systemd-tmpfiles";
    homepage = "https://codeberg.org/Gardenhouse/seedfiles";
    mainProgram = "seedfiles";
    maintainers = with lib.maintainers; [ es-sai-fi ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
