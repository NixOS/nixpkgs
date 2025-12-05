{
  stdenv,
  lib,
  fetchFromGitHub,
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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ricott1";
    repo = "rebels-in-the-sky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gMT62Uy9rFdtt2LnU7A9bPwH6lRrHVhzXQ03qUoS0CM=";
  };

  cargoHash = "sha256-2Pn8QwviSgznchw56ZpU8J0+aGJOsGlr0OG0Uu5kpZs=";

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
  versionCheckProgramArg = "--version";
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
