{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "river-filtile";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "pkulak";
    repo = "filtile";
    rev = "v${version}";
    hash = "sha256-wBU4CX6KGnTvrBsXvFAlRrvDqvHHbAlVkDqTCJx90G8=";
  };

  cargoHash = "sha256-dmRUcjlmnheCG5drEcJIZbo7haDiu7Qphs6T92V8v/o=";

  nativeBuildInputs = [
    pkg-config
  ];

<<<<<<< HEAD
  meta = {
    description = "Layout manager for the River window manager";
    homepage = "https://github.com/pkulak/filtile";
    license = lib.licenses.gpl3Only;
=======
  meta = with lib; {
    description = "Layout manager for the River window manager";
    homepage = "https://github.com/pkulak/filtile";
    license = licenses.gpl3Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ pkulak ];
    mainProgram = "filtile";
  };
}
