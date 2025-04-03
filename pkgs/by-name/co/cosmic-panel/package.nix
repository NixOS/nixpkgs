{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-panel";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-panel";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-6lt9Rig1pM37B7+nRrR+eYke8umSfYlg8aLB45Q1X+4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EIp9s42deMaB7BDe7RAqj2+CnTXjHCtZjS5Iq8l46A4=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-panel"
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
    homepage = "https://github.com/pop-os/cosmic-panel";
    description = "Panel for the COSMIC Desktop Environment";
    mainProgram = "cosmic-panel";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      qyliss
      nyabinary
      HeitorAugustoLN
    ];
    platforms = lib.platforms.linux;
  };
})
