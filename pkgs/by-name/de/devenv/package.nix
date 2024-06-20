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
      rev = "b24a9318ea3f3600c1e24b4a00691ee912d4de12";
      hash = "sha256-BGvBhepCufsjcUkXnEEXhEVjwdJAwPglCC2+bInc794=";
    };
    buildInputs = old.buildInputs ++ [ libgit2 ];
    doCheck = false;
    doInstallCheck = false;
  });

  version = "1.0.7";
in rustPlatform.buildRustPackage {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    rev = "v${version}";
    hash = "sha256-eTbBvYwGlKExMSTyHQya6+6kdx1rtva/aVfyAZu2NUU=";
  };

  cargoHash = "sha256-fmxXCOrWRM4ZKwQS9vCIh7LonpifyeNGsj/td1CjedA=";

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
