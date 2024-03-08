{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, pango
, pipewire
, seatd
, stdenv
, wayland
, systemd
, libinput
, mesa
, fontconfig
, libglvnd
, libclang
, autoPatchelfHook
, clang
}:

rustPlatform.buildRustPackage rec {
  pname = "niri";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "v${version}";
    hash = "sha256-vO6ak5rT6ntBC20vYC36zcEcHv7Cki9y8A+c7ThfsUg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-ZEWamojE5ZRlhPVv/DK2Mj+QIz7zudw9+AxFD7Onr9Q=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    autoPatchelfHook
    clang
  ];

  buildInputs = [
    wayland
    systemd # For libudev
    seatd # For libseat
    libxkbcommon
    libinput
    mesa # For libgbm
    fontconfig
    stdenv.cc.cc.lib
    pipewire
    pango
  ];

  runtimeDependencies = [
    wayland
    mesa
    libglvnd # For libEGL
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  passthru.providedSessions = ["niri"];

  postInstall = ''
    mkdir -p $out/share/{systemd/user,wayland-sessions,xdg-desktop-portal}

    cp ./resources/niri-session $out/bin/niri-session
    cp ./resources/niri.service $out/share/systemd/user/niri.service
    cp ./resources/niri-shutdown.target $out/share/systemd/user/niri-shutdown.target
    cp ./resources/niri.desktop $out/share/wayland-sessions/niri.desktop
    cp ./resources/niri-portals.conf $out/share/xdg-desktop-portal/niri-portals.conf
  '';

  postFixup = ''
    sed -i "s#/usr#$out#" $out/share/systemd/user/niri.service
  '';

  meta = with lib; {
    description = "A scrollable-tiling Wayland compositor";
    homepage = "https://github.com/YaLTeR/niri";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "niri";
    platforms = platforms.linux;
  };
}
