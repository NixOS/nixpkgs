{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "golines";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "golangci";
    repo = "golines";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-gjm76dGbFTisQdiM0GAQJRcAreQUWIBuqYbLU2ruCNk=";
  };

  vendorHash = "sha256-cLzCpjifb0lc6UaDW2JZBQABixz98EJ4syLapX7I8y8=";

  subPackages = [
    "."
  ];

  meta = {
    description = "Golang formatter that fixes long lines";
    homepage = "https://github.com/golangci/golines";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "golines";
  };
})
