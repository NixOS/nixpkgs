{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dbus,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lxmf-rs";
  version = "0.1.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FreeTAKTeam";
    repo = "lxmf-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XpjpRpz/r18Kq38pcKrO9O663cVNZmPY/4VH59Qidzo=";
  };

  cargoHash = "sha256-6l3xb95OTm2sc8nku6fB+3CuJo3sAuukw2bndWtbOtk=";

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
