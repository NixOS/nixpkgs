{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixdoc";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FW8yZLO+hVDn2vs4pEUfjMM/5P508WKCLxd4AozLElk=";
  };

  cargoHash = "sha256-pV/KEg3/UaT7bbgtRgjZZGq+RVyN1xY28YqzfslYoQo=";

  meta = {
    description = "Generate documentation for Nix functions";
    mainProgram = "nixdoc";
    homepage = "https://github.com/nix-community/nixdoc";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      infinisil
      hsjobeki
    ];
    platforms = lib.platforms.unix;
  };
})
