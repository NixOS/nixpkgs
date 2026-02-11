{
  lib,
  buildGo124Module,
  fetchFromGitHub,
}:
buildGo124Module rec {
  pname = "gci";
  version = "0.13.7";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = "gci";
    rev = "v${version}";
    sha256 = "sha256-vSVa0fTGKf8H1cURFD0dha65TgOLMa43NuA043TEFu4=";
  };

  vendorHash = "sha256-NWVhuJAWwZ9EPLq/PY8nqqRXXPgahGdFNVqBTDvCnMw=";

  meta = {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ krostar ];
  };
}
