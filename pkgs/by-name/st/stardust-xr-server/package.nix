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
  mesa,
  openxr-loader,
  pkg-config,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "stardust-xr-server";
  version = "0.45.1";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "server";
    rev = "refs/tags/${version}";
    hash = "sha256-SBAt6CyOt28elXGybAx7glLDEs8vYkoaTXHoEaPEuKk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-FNsjbcdiI46nNSWMd4smn5Lg53UU4NFmCfV8ZfaJLs0=";
      "stardust-xr-0.45.0" = "sha256-FdbtBgvknjGW2MnrS2QMwtTSrRjd+KezC3kY5JqRH2s=";
      "stereokit-macros-0.1.0" = "sha256-cs/fbbqMSaoJZIjDEcqjoqlhldtVTRPBczJ4GD8+Sks=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    libGL
    libxkbcommon
    mesa
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
