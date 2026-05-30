{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  cmake,
  pkg-config,
  alsa-lib,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  withRadio ? false,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rebels-in-the-sky";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "ricott1";
    repo = "rebels-in-the-sky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-alXqHtaGtv2zPt1OpNyEwHpQ+GKhS8xqOQFa5PvCsqc=";
  };

  cargoHash = "sha256-PvSOjuK1cObDuZeAKYEEqwezCuv7RM1W/aimrc4QV28=";

  cargoPatches = [
    (fetchpatch {
      # The lock file was updated after the release
      url = "https://github.com/ricott1/rebels-in-the-sky/commit/4cd33144b7e2e6297c5e0d6a6a0e46bc976279d0.patch";
      hash = "sha256-HUzABNtpBgts7rtuPB/OCtCTQk+XsLGEOyRRgy3uIdI=";
    })
  ];

  patches = lib.optionals (!withRadio) [
    ./disable-radio.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rustPlatform.bindgenHook
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  nativeCheckInputs = [
    # Save system tests write to home dir
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/rebels";
  # Darwin: "Error: Operation not permitted (os error 1)"
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "P2P terminal game about spacepirates playing basketball across the galaxy";
    longDescription = ''
      It's the year 2101. Corporations have taken over the world. The only way to be free is
      to join a pirate crew and start plundering the galaxy. The only means of survival is
      to play basketball.

      Now it's your turn to go out there and make a name for yourself. Create your crew and
      start wandering the galaxy in search of worthy basketball opponents.
    '';
    homepage = "https://frittura.org/";
    changelog = "https://github.com/ricott1/rebels-in-the-sky/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      [ gpl3Only ]
      # The original game soundtrack was generated using AI so its licensing is unclear.
      # I couldn't find licensing information regarding other radio stations, so I'm
      # assuming they're nonfree.
      ++ lib.optionals withRadio [ unfree ];
    maintainers = with lib.maintainers; [ marcin-serwin ];
    mainProgram = "rebels";
  };
})
