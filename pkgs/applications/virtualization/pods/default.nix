{ lib
, stdenv
, fetchFromGitHub
, cargo
, desktop-file-utils
, glib
, gtk4
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, wrapGAppsHook4
, gtksourceview5
, libadwaita
, libpanel
, vte-gtk4
}:

stdenv.mkDerivation rec {
  pname = "pods";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "marhkb";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9gSLjnBExxLhbrsD2nYPwoUCmc2gE+afblQOcnWPap0=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "containers-api-0.8.0" = "sha256-jttd4n45OcsWWBu7nAL0Ny0ILjsAKtAIQN+Vkv34gdM=";
      "podman-api-0.10.0" = "sha256-P3a/OgH26EFWJjYkEob4Cg90U5cR/fBF0LcFlosJlcU=";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  meta = with lib; {
    description = "A podman desktop application";
    homepage = "https://github.com/marhkb/pods";
    changelog = "https://github.com/marhkb/pods/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
