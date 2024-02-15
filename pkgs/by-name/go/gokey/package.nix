{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "gokey";
  version = "0.1.2-unstable-2023-11-16";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "gokey";
    rev = "26fcef24d123e0eaf7b92224e6880f529f94aa9f";
    hash = "sha256-nt4fO8NKYfRkpoC1z8zDrEZC7+fo6sU/ZOHCMHIAT58=";
  };

  vendorHash = "sha256-ZDCoRE2oP8ANsu7jfLm3BMLzXdsq1dhsEigvwWgKk54=";

  meta = with lib; {
    homepage = "https://github.com/cloudflare/gokey";
    description = "Vault-less password store";
    license = licenses.bsd3;
    maintainers = [ maintainers.confus ];
    mainProgram = "gokey";
  };
}
