{
  fetchFromGitHub,
  installShellFiles,
  lib,
  pkg-config,
  rustPlatform,
  stdenv,
  withSixel ? false,
  libsixel,
  libxrandr,
  libx11,
  withSki ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "menyoki";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "menyoki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2l4umaJVsDCR/avrRGkBz+3zlkf7m6G7b3+dcEo4Wyw=";
  };

  cargoHash = "sha256-EC7viho1Tv015MjbLPdia8b64sw2+6/7vRwNjP5Mvyg=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs =
    lib.optional withSixel libsixel
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libx11
      libxrandr
    ];

  buildNoDefaultFeatures = !withSki;
  buildFeatures = lib.optional withSixel "sixel";

  checkFlags = [
    # sometimes fails on lower end machines
    "--skip=record::fps::tests::test_fps"
  ];

  postInstall = ''
    installManPage man/*
    installShellCompletion completions/menyoki.{bash,fish,zsh}
  '';

  meta = {
    description = "Screen{shot,cast} and perform ImageOps on the command line";
    homepage = "https://menyoki.cli.rs/";
    changelog = "https://github.com/orhun/menyoki/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "menyoki";
  };
})
