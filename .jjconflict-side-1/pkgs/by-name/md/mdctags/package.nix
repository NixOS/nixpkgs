{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "mdctags";
  version = "0.1.0-unstable-2020-07-11"; # v0.1.0 does not build with our rust version

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "wsdjeg";
    repo = "mdctags.rs";
    rev = "0ed9736ea0c77e6ff5b560dda46f5ed0a983ed82";
    hash = "sha256-K3cZIPqiv8PqnNMPaCI5GW3DgDCA1nKmm/SzBB/0+ZE=";
  };

  cargoHash = "sha256-xg9tBBo3Al8x0HkgRnfdZybcjaHsNMv/Ot3NwGiHkBg=";

  meta = {
    description = "Tags for markdown file";
    homepage = "https://github.com/wsdjeg/mdctags.rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
    mainProgram = "mdctags";
  };
}
