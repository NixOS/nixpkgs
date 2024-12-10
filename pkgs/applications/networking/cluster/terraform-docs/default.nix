{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_21,
}:
buildGoModule rec {
  pname = "terraform-docs";
  version = "0.17.0";

  go = go_1_21;

  src = fetchFromGitHub {
    owner = "terraform-docs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HkkW6JX5wcGElmr6CiSukyeS/8rz4CUThy8rZfx4hbo=";
  };

  patches = [ ./update-to-go-1.21.patch ];

  vendorHash = "sha256-ZHWAiXJG8vCmUkf6GNxoIJbIEjEWukLdrmdIb64QleI=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A utility to generate documentation from Terraform modules in various output formats";
    mainProgram = "terraform-docs";
    homepage = "https://github.com/terraform-docs/terraform-docs/";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
