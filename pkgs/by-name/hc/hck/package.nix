{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
<<<<<<< HEAD
  version = "0.11.5";
=======
  version = "0.11.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "hck";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cycM40fm0bc6SCgGsMTKFVPUtjcXGpoMo3KhDDo74ZQ=";
  };

  cargoHash = "sha256-1Kaob5OZiM9WZ6lwuRvuDMtHVolRPjApQtQ52TQhs8A=";
=======
    hash = "sha256-XnkLKslZY2nvjO5ZeTIBJ0Y47/JPhfIS/F5KKqm5iwI=";
  };

  cargoHash = "sha256-NKyBC/kD2tq61su7tUsSPQ2Rr4YBYUsotL55aCoFNGw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      unlicense
    ];
    maintainers = with lib.maintainers; [
      gepbird
    ];
    mainProgram = "hck";
  };
}
