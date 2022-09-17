{ fetchFromGitHub
, installShellFiles
, lib
, pkg-config
, rustPlatform
, stdenv
, withSixel ? false
, libsixel
, libX11
, libXrandr
, AppKit
, withSki ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "menyoki";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z0OpRnjVfU6vcyZsxkdD2x3l+a9GkDHZcFveGunDYww=";
  };

  cargoSha256 = "sha256-uSoyfgPlsHeUwnTHE49ErrlB65wcfl5dxn/YrW5EKZw=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional stdenv.isLinux pkg-config;

  buildInputs = lib.optional withSixel libsixel
    ++ lib.optionals stdenv.isLinux [ libX11 libXrandr ]
    ++ lib.optional stdenv.isDarwin AppKit;

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
  };
}
