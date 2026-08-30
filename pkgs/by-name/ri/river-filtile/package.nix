{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "river-filtile";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "pkulak";
    repo = "filtile";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wBU4CX6KGnTvrBsXvFAlRrvDqvHHbAlVkDqTCJx90G8=";
  };

  cargoHash = "sha256-dmRUcjlmnheCG5drEcJIZbo7haDiu7Qphs6T92V8v/o=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Layout manager for the River window manager";
    homepage = "https://github.com/pkulak/filtile";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pkulak ];
    mainProgram = "filtile";
  };
})
