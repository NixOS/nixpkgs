{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goread";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "TypicalAM";
    repo = "goread";
    rev = "v${version}";
    hash = "sha256-SRVXcdgtRpWqvO28CnUcx40nFJnG+Hd94Ezgaj5xK6A=";
  };

  vendorHash = "sha256-/kxEnw8l9S7WNMcPh1x7xqiQ3L61DSn6DCIvJlyrip0=";

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
