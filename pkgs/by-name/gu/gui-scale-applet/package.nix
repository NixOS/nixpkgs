{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  fetchpatch,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gui-scale-applet";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    tag = finalAttrs.version;
    hash = "sha256-1zCANfgWgDkSTvpvgxzve/ErGel2WF1RxIhv/EdIxxo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-2yfeZKsakAeAtNcK8v7hqwMBm7o7HhiNU5mgPevhNvo=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  patches = [
    (fetchpatch {
      name = "fix-icon-install.patch";
      url = "https://patch-diff.githubusercontent.com/raw/cosmic-utils/gui-scale-applet/pull/18.diff?full_index=1";
      hash = "sha256-vP3yZsf5rDRTsi5PwZYmPOqGN6o9jySWlSt5/hXb/XA=";
    })
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/gui-scale-applet"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/cosmic-utils/gui-scale-applet/releases/tag/${finalAttrs.version}";
    description = "Tailscale applet for the COSMIC Desktop Environment";
    homepage = "https://github.com/cosmic-utils/gui-scale-applet";
    license = lib.licenses.bsd3;
    mainProgram = "gui-scale-applet";
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
