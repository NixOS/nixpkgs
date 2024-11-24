{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "natls";
  version = "2.1.14";

  src = fetchFromGitHub {
    owner = "willdoescode";
    repo = "nat";
    rev = "v${version}";
    sha256 = "sha256-4x92r6V9AvEO88gFofPTUt+mS7ZhmptDn/8O4pizSRg=";
  };

  cargoHash = "sha256-Am4HmfmhskKxcp1iWod5z3caHwsdo31qCaVi0UxTXAg=";

  meta = with lib; {
    description = "'ls' replacement you never knew you needed";
    homepage = "https://github.com/willdoescode/nat";
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "natls";
  };
}
