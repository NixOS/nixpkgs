{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lefthook";
  version = "0.7.4";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "evilmartians";
    repo = "lefthook";
    sha256 = "sha256-wW8Obh0YmAZHKrXLQ8364+TrAmLIYKRir2qXdWLtVkE=";
  };

  vendorSha256 = "sha256-XR7xJZfgt0Hx2DccdNlwEmuduuVU8IBR0pcIUyRhdko=";

  doCheck = false;

  meta = with lib; {
    description = "Fast and powerful Git hooks manager for any type of projects";
    homepage = "https://github.com/Arkweid/lefthook";
    license = licenses.mit;
    maintainers = with maintainers; [ rencire ];
  };
}
