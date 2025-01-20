{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "goverter";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VgwmnB6FP7hlUrZpKun38T4K2YSDl9yYuMjdzsEhCF4=";
  };

  vendorHash = "sha256-uQ1qKZLRwsgXKqSAERSqf+1cYKp6MTeVbfGs+qcdakE=";

  subPackages = [ "cmd/goverter" ];

  meta = with lib; {
    license = licenses.mit;
    description = "Generate type-safe Go converters by defining function signatures.";
    homepage = "https://github.com/jmattheis/goverter";
    maintainers = with maintainers; [ krostar ];
  };
}
