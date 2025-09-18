{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
  version = "0.13.7";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = "gci";
    rev = "v${version}";
    sha256 = "sha256-vSVa0fTGKf8H1cURFD0dha65TgOLMa43NuA043TEFu4=";
  };

  vendorHash = "sha256-NWVhuJAWwZ9EPLq/PY8nqqRXXPgahGdFNVqBTDvCnMw=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [ krostar ];
  };
}
