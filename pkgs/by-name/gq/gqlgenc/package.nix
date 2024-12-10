{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.25.3";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-sIXPd/+BVaywAAt2myNOBaAjy/eTY6C8TdSuOoikr0E=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-YGFMQrxghJIgmiwEPfEqaACH7OETVkD8O7oUhm9foJo=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ wattmto ];
  };
}
