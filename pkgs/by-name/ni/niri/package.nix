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
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "niri";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "v${version}";
    hash = "sha256-VTtXEfxc3OCdtdYiEdtftOQ7gDJNb679Yw8v1Lu3lhY=";
  };

  patches = [
    (fetchpatch {
      name = "revert-viewporter.patch";
      url = "https://github.com/YaLTeR/niri/commit/40cec34aa4a7f99ab12b30cba1a0ee83a706a413.patch";
      hash = "sha256-3fg8v0eotfjUQY6EVFEPK5BBIBrr6vQpXbjDcsw2E8Q=";
    })
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-sXdixfPLAUIIVK+PhqRuMZ7XKNJIGkWNlH8nBzXlxCU=";
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

  postPatch = ''
    patchShebangs ./resources/niri-session
    substituteInPlace ./resources/niri.service \
      --replace-fail '/usr/bin' "$out/bin"
  '';

  postInstall = ''
    install -Dm0755 ./resources/niri-session -t $out/bin
    install -Dm0644 resources/niri.desktop -t $out/share/wayland-sessions
    install -Dm0644 resources/niri-portals.conf -t $out/share/xdg-desktop-portal
    install -Dm0644 resources/niri{-shutdown.target,.service} -t $out/share/systemd/user
  '';

  meta = with lib; {
    description = "A scrollable-tiling Wayland compositor";
    homepage = "https://github.com/YaLTeR/niri";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iogamaster foo-dogsquared sodiboo ];
    mainProgram = "niri";
    platforms = platforms.linux;
  };
}
