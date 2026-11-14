{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sammler";
  version = "20210523-${lib.strings.substring 0 7 rev}";
  rev = "259b9fc6155f40758e5fa480683467c35df746e7";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "Sammler";
    inherit rev;
    hash = "sha256-rEgb2iJfI+fxsleqZf2gIvBDCoRzy/XizDcxvPRAW78=";
  };

  vendorHash = "sha256-0ZBPLONUZyazZ22oLO097hdX5xuHx2G6rZCAsCwqq4s=";

  subPackages = [ "." ];

  meta = {
    description = "Tool to extract useful data from documents";
    mainProgram = "sammler";
    homepage = "https://github.com/redcode-labs/Sammler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
