{
  lib,
  stdenv,
  fetchFromGitLab,
  cargo,
  rustc,
  rustPlatform,
  tree,
  git,
  wl-clipboard,
  dmenu-wayland,
}:
stdenv.mkDerivation rec {
  pname = "seniorpw";
  version = "0.8.1";

  src = fetchFromGitLab {
    owner = "retirement-home";
    repo = "seniorpw";
    tag = version;
    hash = "sha256-t5LSqeG1N9PbjS/KqwMrq30dUrxR26h692ttCFhvhcU=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  cargoRoot = "src/seniorpw";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src cargoRoot;
    hash = "sha256-6/GSrjikqC6pr7iRYFP48k2iTQLO1/djzu4/PVvGgf8";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '--locked ' '--offline ' \
      --replace-fail '$(PREFIX)/local/bin' '$(PREFIX)/bin' \
      --replace-fail '$(PREFIX)/local/share' '$(PREFIX)/share'
  '';

  installPhase = ''
    make install PREFIX=$out
  '';

  propagatedBuildInputs = [
    tree
    git
    wl-clipboard
    dmenu-wayland
  ];

  meta = {
    description = "Password manager using age as backend, inspired by pass";
    homepage = "https://gitlab.com/retirement-home/seniorpw";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ claes ];
    platforms = lib.platforms.unix;
    mainProgram = "seniorpw";
  };
}
