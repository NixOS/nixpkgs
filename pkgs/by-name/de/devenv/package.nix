{ stdenv
, lib
, openssl
, darwin
, libgit2
, makeWrapper
, nix
, pkg-config
, rustPlatform
, cachix
, fetchFromGitHub
}:

let
  devenv_nix = nix.overrideAttrs (old: {
    version = "2.21-devenv";
    src = fetchFromGitHub {
      owner = "domenkozar";
      repo = "nix";
      rev = "c5bbf14ecbd692eeabf4184cc8d50f79c2446549";
      hash = "sha256-zvCqeUO2GLOm7jnU23G4EzTZR7eylcJN+HJ5svjmubI=";
    };
    buildInputs = old.buildInputs ++ [ libgit2 ];
    doCheck = false;
    doInstallCheck = false;
  });

  version = "1.0.1";
in rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "v${version}";
    hash = "sha256-9LnGe0KWqXj18IV+A1panzXQuTamrH/QcasaqnuqiE0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  postInstall = ''
    wrapProgram $out/bin/devenv --set DEVENV_NIX ${devenv_nix} --prefix PATH ":" "$out/bin:${cachix}/bin"
  '';

  meta = {
    changelog = "https://github.com/cachix/devenv/releases/tag/v${version}";
    description = "Fast, Declarative, Reproducible, and Composable Developer Environments";
    homepage = "https://github.com/cachix/devenv";
    license = lib.licenses.asl20;
    mainProgram = "devenv";
    maintainers = with lib.maintainers; [ domenkozar drupol ];
  };
}
