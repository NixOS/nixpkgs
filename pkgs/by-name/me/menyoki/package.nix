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
  withSki ? true,
}:

rustPlatform.buildRustPackage rec {
  pname = "menyoki";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "menyoki";
    rev = "v${version}";
    sha256 = "sha256-owP3G1Rygraifdc4iPURQ1Es0msNhYZIlfrtj0CSU6Y=";
  };

  cargoHash = "sha256-6FRc/kEhGJXIZ+6GXeYj5j7QVmvZgIQgtDPvt94hlho=";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs =
    lib.optional withSixel libsixel
    ++ lib.optionals stdenv.hostPlatform.isLinux (
      with xorg;
      [
        libX11
        libXrandr
      ]
    );

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
    changelog = "https://github.com/orhun/menyoki/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "menyoki";
  };
}
