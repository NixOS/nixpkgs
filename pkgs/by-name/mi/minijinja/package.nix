{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "minijinja";
  version = "3.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "minijinja";
    rev = finalAttrs.version;
    hash = "sha256-D/CiEoGJE1+wjLv53xMTNJSALpBW6siK27jVQoi3oEE=";
  };

  cargoHash = "sha256-KYkGDyOQ7QLT9/nt9s4Y6S5kuTvpTA8Cu8qi57fi+dI=";

  # The tests relies on the presence of network connection
  doCheck = false;

  cargoBuildFlags = [ "--bin=minijinja-cli" ];

  meta = {
    description = "Command Line Utility to render MiniJinja/Jinja2 templates";
    homepage = "https://github.com/mitsuhiko/minijinja";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ psibi ];
    changelog = "https://github.com/mitsuhiko/minijinja/blob/${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "minijinja-cli";
  };
})
