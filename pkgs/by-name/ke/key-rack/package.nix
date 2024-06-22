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
  version = "0-unstable-2024-06-21";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "sophie-h";
    repo = "key-rack";
    rev = "d6081b814ee2f91bc3d49734aeebcf7f512ac19a";
    hash = "sha256-apAvethMUpsosKxk2DT310AIjsF755u36xm3cMYpRaM=";
  };

  postPatch = ''
    patchShebangs {,.}*
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-JSJnu81rGOCFYom0fPXlj3LjlvxEvopF0YVay8ah8o4=";
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "View and edit your apps’ keys";
    homepage = "https://gitlab.gnome.org/sophie-h/key-rack";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "key-rack";
  };
})
