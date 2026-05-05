{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lxmf-rs";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FreeTAKTeam";
    repo = "lxmf-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2bxSBw4ISb7xOQiazrSVytvW9cW4i7azB7U8sos7+yA=";
  };

  cargoHash = "sha256-EqRL1JoAdyh46Ev8S/Ta6RsbhhaNH6dlisudpO2D1Rw=";

  cargoBuildFlags = [
    "--bin"
    "lxmf-cli"
    "--bin"
    "lxmd"
    "--bin"
    "reticulumd"
  ];

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus.dev
  ];
})
