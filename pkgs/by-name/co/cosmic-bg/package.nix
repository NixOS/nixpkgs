{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fetchpatch,
  cosmic-wallpapers,
  libcosmicAppHook,
  just,
  nasm,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-bg";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-bg";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-4b4laUXTnAbdngLVh8/dD144m9QrGReSEjRZoNR6Iks=";
  };

  patches = [
    # TOOD: This is merged and will be included in the 7th Alpha release, remove it then.
    (fetchpatch {
      url = "https://github.com/pop-os/cosmic-bg/commit/6a824a7902d7cc72b5a3117b6486603a1795a1d6.patch";
      hash = "sha256-jL0az87BlJU99lDF3jnE74I4m/NV6NViyYXTfZoBDM4=";
    })
  ];

  postPatch = ''
    substituteInPlace config/src/lib.rs data/v1/all \
      --replace-fail '/usr/share/backgrounds/cosmic/orion_nebula_nasa_heic0601a.jpg' \
      "${cosmic-wallpapers}/share/backgrounds/cosmic/orion_nebula_nasa_heic0601a.jpg"
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-GLXooTjcGq4MsBNnlpHBBUJGNs5UjKMQJGJuj9UO2wk=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    nasm
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-bg"
  ];

  passthru = {
    tests = {
      inherit (nixosTests)
        cosmic
        cosmic-autologin
        cosmic-noxwayland
        cosmic-autologin-noxwayland
        ;
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version"
        "unstable"
        "--version-regex"
        "epoch-(.*)"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-bg";
    description = "Applies Background for the COSMIC Desktop Environment";
    license = lib.licenses.mpl20;
    maintainers = lib.teams.cosmic.members;
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-bg";
  };
})
