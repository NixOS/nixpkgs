{
  fetchFromGitHub,
  installShellFiles,
  lib,
  pkg-config,
  rustPlatform,
  stdenv,
  withSixel ? false,
  libsixel,
  xorg,
  AppKit,
  withSki ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "menyoki";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-owP3G1Rygraifdc4iPURQ1Es0msNhYZIlfrtj0CSU6Y=";
  };

  cargoHash = "sha256-NtXjlGkX8AzSw98xHPymzdnTipMIunyDbpSr4eVowa0=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs =
    lib.optional withSixel libsixel
    ++ lib.optionals stdenv.hostPlatform.isLinux (
      with xorg;
      [
        libX11
        libXrandr
      ]
    )
    ++ lib.optional stdenv.hostPlatform.isDarwin AppKit;

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

  meta = with lib; {
    description = "Screen{shot,cast} and perform ImageOps on the command line";
    homepage = "https://menyoki.cli.rs/";
    changelog = "https://github.com/orhun/menyoki/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "menyoki";
  };
}
