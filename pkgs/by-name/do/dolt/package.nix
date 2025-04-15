{
  fetchFromGitHub,
  lib,
  buildGoModule,
}:

buildGoModule rec {
  pname = "dolt";
  version = "1.50.9";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-d4n4Cz4FvSMznTqHs5cD18Y1xE6p8umGr7PqtI5k6Zg=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-+UD1J1FSIfYtRY+0shCw/j5LPbc2V6Ydmc0bf8yj2EI=";
  proxyVendor = true;
  doCheck = false;

  meta = with lib; {
    description = "Relational database with version control and CLI a-la Git";
    mainProgram = "dolt";
    homepage = "https://github.com/dolthub/dolt";
    license = licenses.asl20;
    maintainers = with maintainers; [ danbst ];
  };
}
