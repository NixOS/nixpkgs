{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goread";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "TypicalAM";
    repo = "goread";
    rev = "v${version}";
    hash = "sha256-a30i8eh7asc4nlomrEFV3EgwMs69UUyXPWiRQ5w6Xvc=";
  };

  vendorHash = "sha256-S/0uuy/G7ZT239OgKaOT1dmY+u5/lnZKL4GtbEi2zCI=";

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
