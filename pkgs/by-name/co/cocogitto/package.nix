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
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    hash = "sha256-VorWk7E+I1hU8Hc+WF47+V483E/xPjf7Glqp7iA1t5g=";
  };

  cargoHash = "sha256-pjCLlti/6CITFLN3UxYujP/K6j2bSAu1OS1zw3YiSFM=";

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
