{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
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
, autoPatchelfHook
, clang
}:

rustPlatform.buildRustPackage rec {
  pname = "niri";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "v${version}";
    hash = "sha256-13xynDWoOqogUKZTf6lz267hEQGdCE+BE6acs2G3j8k=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-4lmCbdW+fOnPWEDAbKk4LFcr9KK+akjUJqiwm0pK8Uw=";
      "libspa-0.8.0" = "sha256-R68TkFbzDFA/8Btcar+0omUErLyBMm4fsmQlCvfqR9o=";
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

  passthru.providedSessions = [ "niri" ];

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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Scrollable-tiling Wayland compositor";
    homepage = "https://github.com/YaLTeR/niri";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iogamaster foo-dogsquared sodiboo ];
    mainProgram = "niri";
    platforms = platforms.linux;
  };
}
