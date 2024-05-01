{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk3
, librsvg
, gtk-layer-shell
, stdenv
, libdbusmenu-gtk3
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = "eww";
    rev = "refs/tags/v${version}";
    hash = "sha256-rzDnplFJNiHe+XbxbhZMEhPJMiJsmdVqtZxlxhzzpTk=";
  };

  cargoHash = "sha256-n9nd5E/VO+0BgkhrfQpeihlIkoVQRf6CMiPCK5opvvw=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [
    gtk3
    gtk-layer-shell
    libdbusmenu-gtk3
    librsvg
  ];

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ coffeeispower eclairevoyant figsoda lom w-lfchen ];
    mainProgram = "eww";
    broken = stdenv.isDarwin;
  };
}
