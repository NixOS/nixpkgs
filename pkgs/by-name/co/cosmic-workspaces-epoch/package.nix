{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  libinput,
  libgbm,
  udev,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-workspaces-epoch";
  version = "1.0.0-alpha.5.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces-epoch";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-lAK7DZWwNMr30u6Uopew9O/6FIG6e2SgcdA+cD/K5Ok=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-w1lQdzy2mJ5NfqngvOLqFCxyhWgvIySDDXCCtCCtTjg=";

  separateDebugInfo = true;

  nativeBuildInputs = [
    pkg-config
    libcosmicAppHook
  ];

  buildInputs = [
    libinput
    libgbm
    udev
  ];

  dontCargoInstall = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CARGO_TARGET_DIR=target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "unstable"
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-workspaces-epoch";
    description = "Workspaces Epoch for the COSMIC Desktop Environment";
    mainProgram = "cosmic-workspaces";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nyabinary ];
    platforms = lib.platforms.linux;
  };
})
