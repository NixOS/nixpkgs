{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  libinput,
  libglvnd,
  libgbm,
  udev,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-workspaces-epoch";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    rev = "epoch-${version}";
    hash = "sha256-lAK7DZWwNMr30u6Uopew9O/6FIG6e2SgcdA+cD/K5Ok=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-w1lQdzy2mJ5NfqngvOLqFCxyhWgvIySDDXCCtCCtTjg=";

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxkbcommon
    libinput
    libglvnd
    libgbm
    udev
    wayland
  ];

  postInstall = ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp data/*.desktop $out/share/applications/
    cp data/*.svg $out/share/icons/hicolor/scalable/apps/
  '';

  # Force linking to libEGL, which is always dlopen()ed, and to
  # libwayland-client, which is always dlopen()ed except by the
  # obscure winit backend.
  RUSTFLAGS = map (a: "-C link-arg=${a}") [
    "-Wl,--push-state,--no-as-needed"
    "-lEGL"
    "-lwayland-client"
    "-Wl,--pop-state"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    mainProgram = "cosmic-workspaces";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nyabinary ];
    platforms = platforms.linux;
  };
}
