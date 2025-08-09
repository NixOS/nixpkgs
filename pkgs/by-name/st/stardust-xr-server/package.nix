{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  cmake,
  cpm-cmake,
  fontconfig,
  libGL,
  libxkbcommon,
  libgbm,
  openxr-loader,
  pkg-config,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-server";
  version = "0.44.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "server";
    tag = version;
    hash = "sha256-sCatpWDdy7NFWOWUARjN3fZMDVviX2iV79G0HTxfYZU=";
  };

  cargoHash = "sha256-jCtMCZG3ku30tabTnVdGfgcLl5DoqhkJpLKPPliJgDU=";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    libGL
    libxkbcommon
    libgbm
    openxr-loader
    xorg.libX11
    xorg.libXfixes
  ];

  CPM_SOURCE_CACHE = "./build";

  postPatch = ''
    install -D ${cpm-cmake}/share/cpm/CPM.cmake $(echo $cargoDepsCopy/stereokit-sys-*/StereoKit)/build/cpm/CPM_0.32.2.cmake
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland compositor and display server for 3D applications";
    homepage = "https://stardustxr.org/";
    changelog = "https://github.com/StardustXR/server/releases";
    license = lib.licenses.gpl2Plus;
    mainProgram = "stardust-xr-server";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}
