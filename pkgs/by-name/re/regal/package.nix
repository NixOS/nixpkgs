{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "regal";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-3Q37ukeqf3n8UhriQNCWyRCgWOcxwO4TsNcsEnJn5eg=";
  };

  vendorHash = "sha256-ejTBfoDYMt5Jpuq+uNgpdHCafR7IUVr8OFB84+m/ZFg=";

  meta = with lib; {
    description = "a linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/StyraInc/regal";
    license = licenses.asl20;
    maintainers = with maintainers; [ rinx ];
  };
}
