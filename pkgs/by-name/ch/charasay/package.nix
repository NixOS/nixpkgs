{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "charasay";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "latipun7";
    repo = "charasay";
    rev = "v${version}";
    hash = "sha256-NB2GDDFH9IW/c0acMojYHuzPrx0J3tjlDqjQa6ZRbN4=";
  };

  cargoHash = "sha256-i2CvwQXKKfYLdK0tKf/w4TepPyMo99v1I+kIr00PWcY=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd chara \
      --bash <($out/bin/chara completions --shell bash) \
      --fish <($out/bin/chara completions --shell fish) \
      --zsh <($out/bin/chara completions --shell zsh)
  '';

  meta = with lib; {
    description = "Future of cowsay - Colorful characters saying something";
    homepage = "https://github.com/latipun7/charasay";
    license = licenses.mit;
    maintainers = with maintainers; [ hmajid2301 ];
    mainProgram = "chara";
  };
}
