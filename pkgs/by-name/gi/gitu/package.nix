{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitu";
<<<<<<< HEAD
  version = "0.40.0";
=======
  version = "0.38.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "altsem";
    repo = "gitu";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JNa9foW5z0NrXk5r/Oep20+u7YRhkzMIZQPHlZVifGI=";
  };

  cargoHash = "sha256-mQ5xXYVmadmNx57nnJGICZ2dhll+V3PkYK+hwTTfdVE=";
=======
    hash = "sha256-eOt16jeWLQ7nxKMBwwDs/4NIf/rzr+q6s0QHcY+zzSk=";
  };

  cargoHash = "sha256-pJs8uTim+/TrqzjxCzKHlaZRQudd0dMIZXqlAZU7G1M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  nativeCheckInputs = [
    git
  ];

<<<<<<< HEAD
  meta = {
    description = "TUI Git client inspired by Magit";
    homepage = "https://github.com/altsem/gitu";
    changelog = "https://github.com/altsem/gitu/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evanrichter ];
=======
  meta = with lib; {
    description = "TUI Git client inspired by Magit";
    homepage = "https://github.com/altsem/gitu";
    changelog = "https://github.com/altsem/gitu/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ evanrichter ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "gitu";
  };
}
