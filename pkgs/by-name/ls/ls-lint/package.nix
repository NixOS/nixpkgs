{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ls-lint";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "loeffel-io";
    repo = "ls-lint";
    rev = "v${version}";
    sha256 = "sha256-QAUmQAa1gNS2LLyFmOsydOVKZoZMWzu9y7SgbIq1ESk=";
  };

  vendorHash = "sha256-ZqQHxkeV+teL6+Be59GcDJTH9GhGTJnz+OHAeIC9I24=";

  meta = with lib; {
    description = "Extremely fast file and directory name linter";
    mainProgram = "ls_lint";
    homepage = "https://ls-lint.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
