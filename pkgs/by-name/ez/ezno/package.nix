{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ezno";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "kaleidawave";
    repo = "ezno";
    rev = "release/ezno-${version}";
    hash = "sha256-0yLEpNkl7KjBEGxNONtfMjVlWMSKGZ6TbYJMsCeQ3ms=";
  };

  cargoHash = "sha256-v4lgHx+sR58CshZJCUYrtaW4EDFBUKFPJJ6V+eyf5Bc=";

  cargoBuildFlags = [
    "--bin"
    "ezno"
  ];

  meta = with lib; {
    description = "JavaScript compiler and TypeScript checker with a focus on static analysis and runtime performance";
    mainProgram = "ezno";
    homepage = "https://github.com/kaleidawave/ezno";
    changelog = "https://github.com/kaleidawave/ezno/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
