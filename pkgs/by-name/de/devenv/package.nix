{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rustPlatform
, testers

, cachix
, darwin
, libgit2
, nix
, openssl
, pkg-config

, devenv  # required to run version test
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

  version = "1.0.3";
in rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "v${version}";
    hash = "sha256-fnJPqMFoWTYsPNEwbxTxO0h771vZKu+b5Ig4LJQcoRg=";
  };

  cargoHash = "sha256-Qckh7knX3sARMHgn+39ozQj8CnfyEQV4yjJPP2+v2SM=";

  nativeBuildInputs = [ makeWrapper pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  postInstall = ''
    wrapProgram $out/bin/devenv --set DEVENV_NIX ${devenv_nix} --prefix PATH ":" "$out/bin:${cachix}/bin"
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = devenv;
      command = "export XDG_DATA_HOME=$PWD; devenv version";
    };
  };

  meta = {
    changelog = "https://github.com/cachix/devenv/releases/tag/v${version}";
    description = "Fast, Declarative, Reproducible, and Composable Developer Environments";
    homepage = "https://github.com/cachix/devenv";
    license = lib.licenses.asl20;
    mainProgram = "devenv";
    maintainers = with lib.maintainers; [ domenkozar drupol ];
  };
}
