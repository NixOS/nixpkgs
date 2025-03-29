{
  lib,
  bign-handheld-thumbnailer,
  fetchFromGitHub,
  glib,
  nix-update-script,
  pkg-config,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "bign-handheld-thumbnailer";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "MateusRodCosta";
    repo = "bign-handheld-thumbnailer";
    tag = "v${version}";
    hash = "sha256-DJbJ4l1QqaEuBI5lja3iCEq0QnlAgwPXg2N4MBPBvUY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cnl8H4+rqIS0sfwq+breJSuabX3vT16xLtaVnK96Q/4=";

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ glib ];

  passthru = {
    tests.version = testers.testVersion {
      package = bign-handheld-thumbnailer;
      version = "v${version}";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Thumbnailer for Nintendo handheld systems (Nintendo DS and 3DS) roms and files";
    homepage = "https://github.com/MateusRodCosta/bign-handheld-thumbnailer";
    changelog = "https://github.com/MateusRodCosta/bign-handheld-thumbnailer/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "bign-handheld-thumbnailer";
    # This is based on GIO
    inherit (glib.meta) platforms;
  };
}
