{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  libgit2,
}:

rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = "cocogitto";
    tag = version;
    hash = "sha256-aAVoPPeuJN6QPcuc3oBF93dP6U+74bAoSDw93XR01Vo=";
  };

  cargoHash = "sha256-yDpZHkRKsWXXHuSKnzhGrjsFLUFZEpC23tcU3FeUZK8=";

  # Test depend on git configuration that would likely exist in a normal user environment
  # and might be failing to create the test repository it works in.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libgit2 ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cog \
      --bash <($out/bin/cog generate-completions bash) \
      --fish <($out/bin/cog generate-completions fish) \
      --zsh  <($out/bin/cog generate-completions zsh)
  '';

  meta = with lib; {
    description = "Set of cli tools for the conventional commit and semver specifications";
    mainProgram = "cog";
    homepage = "https://github.com/oknozor/cocogitto";
    license = licenses.mit;
    maintainers = [ ];
  };
}
