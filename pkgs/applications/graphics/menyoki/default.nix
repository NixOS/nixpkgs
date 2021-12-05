{ fetchFromGitHub, installShellFiles, lib, pkg-config, rustPlatform, stdenv
, libX11, libXrandr, AppKit, withSki ? true }:

rustPlatform.buildRustPackage rec {
  pname = "menyoki";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wEPt96z/odQ05hosN+GB5KLsCu8onR9WWamofJayhwU=";
  };

  cargoSha256 = "sha256-nwxBreouL3Z47zHSH+Y/ej7KU2/bXyMQ+Tb7R4U+yKk=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional stdenv.isLinux pkg-config;

  buildInputs = lib.optionals stdenv.isLinux [ libX11 libXrandr ]
    ++ lib.optional stdenv.isDarwin AppKit;

  buildNoDefaultFeatures = !withSki;

  postInstall = ''
    installManPage man/*
    installShellCompletion completions/menyoki.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Screen{shot,cast} and perform ImageOps on the command line";
    homepage = "https://menyoki.cli.rs/";
    changelog =
      "https://github.com/orhun/menyoki/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
