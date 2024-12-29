{
  fetchFromGitHub,
  lib,
  libcosmicAppHook,
  libinput,
  mesa,
  pixman,
  pkg-config,
  rustPlatform,
  seatd,
  stdenv,
  systemd,
  udev,
  useSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  useXWayland ? true,
  xwayland,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-comp";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-comp";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-agKyMb3bDExayWbiS8XnZP4UyuBxVjaYjdDW7tq0SL8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WpWOs7hnPzGo073+/JFW7mBrqM+5wAZL98Z+Esei5kc=";

  nativeBuildInputs = [
    libcosmicAppHook
    pkg-config
  ];

  separateDebugInfo = true;
  buildNoDefaultFeatures = !useSystemd;
  buildInputs = [
    libinput
    mesa
    pixman
    seatd
    udev
  ] ++ lib.optionals useSystemd [ systemd ];

  dontCargoInstall = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  preFixup = lib.optionalString useXWayland ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ xwayland ]})
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-comp";
    description = "Compositor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-comp";

    maintainers = with maintainers; [
      nyabinary
      qyliss
      thefossguy
    ];
  };
}
