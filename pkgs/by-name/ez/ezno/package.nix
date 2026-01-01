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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "JavaScript compiler and TypeScript checker with a focus on static analysis and runtime performance";
    mainProgram = "ezno";
    homepage = "https://github.com/kaleidawave/ezno";
    changelog = "https://github.com/kaleidawave/ezno/releases/tag/${src.rev}";
<<<<<<< HEAD
    license = lib.licenses.mit;
=======
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
