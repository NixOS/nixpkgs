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
    rev = "f2611630f143a53b46514d4916af0971d7aab2b5";
    hash = "sha256-VTHS5psVqg4RjSrAs9vPkixsVwwIYE2E4o0vXVN58tE=";
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
