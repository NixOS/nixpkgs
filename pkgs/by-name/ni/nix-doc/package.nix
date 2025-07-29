{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  boost,
  nix,
  pkg-config,
  # Whether to build the nix-doc plugin for Nix
  withPlugin ? false, # no longer needed for nix 2.24
}:

let
  packageFlags = [
    "-p"
    "nix-doc"
  ]
  ++ lib.optionals withPlugin [
    "-p"
    "nix-doc-plugin"
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "nix-doc";
  version = "0.6.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "lf-";
    repo = "nix-doc";
    sha256 = "sha256-9cuNzq+CBA2jz0LkZb7lh/WISIlKklfovGBAbSo1Mgk=";
  };

  doCheck = true;
  buildInputs = lib.optionals withPlugin [
    boost
    nix
  ];

  nativeBuildInputs = lib.optionals withPlugin [
    pkg-config
    nix
  ];

  cargoBuildFlags = packageFlags;
  cargoTestFlags = packageFlags;

  # Packaging support for making the nix-doc plugin load cleanly as a no-op on
  # the wrong Nix version (disabling bindnow permits loading libraries
  # requiring unavailable symbols if they are unreached)
  hardeningDisable = lib.optionals withPlugin [ "bindnow" ];

  # Due to a Rust bug, setting -C relro-level to anything including "off" on
  # macOS will cause link errors
  env = lib.optionalAttrs (withPlugin && stdenv.hostPlatform.isLinux) {
    RUSTFLAGS = "-C relro-level=partial";
  };

  cargoHash = "sha256-EC+Wps6u1qXpv7ByM3NkRVCKRKCaBtC1o2vK8cKqzyU=";

  meta = with lib; {
    description = "Interactive Nix documentation tool";
    longDescription = "An interactive Nix documentation tool providing a CLI for function search, a Nix plugin for docs in the REPL, and a ctags implementation for Nix script";
    homepage = "https://github.com/lf-/nix-doc";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.philiptaron ];
    platforms = platforms.unix;
    mainProgram = "nix-doc";
  };
}
