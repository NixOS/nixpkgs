{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "regal";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "StyraInc";
    repo = "regal";
    rev = "v${version}";
    hash = "sha256-ui4SY8HNpS5CV2zh84w8CYZmZAoNOPxIj/eG+KvKlwI=";
  };

  vendorHash = "sha256-I0aJFvJmmnxlqgeETOyg2/mjGX8lUJz99t56Qe+9uZg=";

  meta = with lib; {
    description = "Linter and language server for Rego";
    mainProgram = "regal";
    homepage = "https://github.com/StyraInc/regal";
    license = licenses.asl20;
    maintainers = with maintainers; [ rinx ];
  };
}
