{
  lib,
  fetchFromGitLab,
  stdenv,
  rustPlatform,
  cargo,
  rustc,
  libadwaita,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  python3,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "key-rack";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "sophie-h";
    repo = "key-rack";
    rev = finalAttrs.version;
    hash = "sha256-mthXtTlyrIChaKKwKosTsV1hK9OQ/zLScjrq6D3CRsg=";
  };

  patches = [ ./0001-fix-E0716.patch ];

  postPatch = ''
    patchShebangs --build build-aux/{checks.sh,read-manifest.py}
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-wCJTm0W+g3+O1t1fR4maqJoxpPM0NeJG7d54MMAH33c=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    meson
    ninja
    pkg-config
    python3
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [ libadwaita ];

  # Workaround for the gettext-sys issue
  # https://github.com/Koka/gettext-rs/issues/114
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16"
  ) "-Wno-error=incompatible-function-pointer-types";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "View and edit your apps’ keys";
    homepage = "https://gitlab.gnome.org/sophie-h/key-rack";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "key-rack";
    platforms = lib.platforms.linux;
  };
})
