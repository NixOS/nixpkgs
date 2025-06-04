{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goread";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "TypicalAM";
    repo = "goread";
    rev = "v${version}";
    hash = "sha256-2C/PejWCwLdWu9n2hpbm3u/UrD56JCJqG+A7xnn/bP4=";
  };

  vendorHash = "sha256-3H2n/VsJHZ/69YR6P38B36mFz85cNHaTtT9N0YQOVew=";

  env.TEST_OFFLINE_ONLY = 1;

  meta = {
    description = "Beautiful program to read your RSS/Atom feeds right in the terminal";
    homepage = "https://github.com/TypicalAM/goread";
    changelog = "https://github.com/TypicalAM/goread/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "goread";
    maintainers = with lib.maintainers; [ schnow265 ];
  };
}
