{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pigeon";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "mna";
    repo = "pigeon";
    rev = "v${version}";
    hash = "sha256-rEkeB5NI51dsLOxd9RnJWmfUP78owOJl6j9t3nz277s=";
  };

  vendorHash = "sha256-vaCgvj/n8MuktaZ2+tQVlQW0LrptQkEQK2qM+YwXXhg=";

  proxyVendor = true;

  subPackages = [ "." ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/mna/pigeon";
    description = "PEG parser generator for Go";
    mainProgram = "pigeon";
    maintainers = with lib.maintainers; [ zimbatm ];
    license = with lib.licenses; [ bsd3 ];
  };
}
