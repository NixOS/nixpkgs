{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "ipinfo";
    repo = "cli";
    tag = "${pname}-${version}";
    hash = "sha256-/0n6DhJlRvTpS7ed0IM9mcKTLuXPx9Y4TMM4xjijKck=";
  };

  vendorHash = null;

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    changelog = "https://github.com/ipinfo/cli/releases/tag/ipinfo-${version}";
    license = with lib.licenses; asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
