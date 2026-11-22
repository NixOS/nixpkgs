{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "patchcord";
  version = "0-unstable-2026-03-29";

  src = fetchFromGitHub {
    owner = "Milkshiift";
    repo = "patchcord";
    rev = "cb0d3d48f0c217e9621c48c576ec340fdfd9b9b7";
    hash = "sha256-MYcLrDVnyhNZ0Wb/X6dNEtc4S1K6k9/XBUyaNCeTli4=";
  };

  cargoHash = "sha256-/IbHvs9SEuulNcWkihwFwaFcqMM0rdFBVjCWgUu7dys=";

  doCheck = false;

  meta = {
    description = "Patcher for GoofCord";
    homepage = "https://github.com/Milkshiift/patchcord";
    license = lib.licenses.osl3;
    platforms = lib.platforms.linux;
  };
}
