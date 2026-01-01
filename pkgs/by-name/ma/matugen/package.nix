{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "matugen";
<<<<<<< HEAD
  version = "3.1.0";
=======
  version = "3.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-TD9XyqFdLIOLRZM7ozQ8gz4PyEQbLGLxB4MbzjLccg4=";
  };

  cargoHash = "sha256-OdJxr01wHqPHgEGIVrLcUv5h1JaYrY1zW9NrYO114OM=";
=======
    hash = "sha256-2VcdnUjIOEMQ87K5wv+Pbgko94PLygp1nrEYcVHk1v4=";
  };

  cargoHash = "sha256-HBAsCrD/njZUYkjcaUaTS7xMwfUWLpDXkpIPWSdCvqo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "matugen";
  };
}
