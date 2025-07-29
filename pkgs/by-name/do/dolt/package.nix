{
  fetchFromGitHub,
  lib,
  buildGoModule,
}:

buildGoModule rec {
  pname = "dolt";
  version = "1.57.3";

  src = fetchFromGitHub {
    owner = "dolthub";
    repo = "dolt";
    rev = "v${version}";
    sha256 = "sha256-zmLSwjoBd9YqbmJq3gtugw4tr9ShiA33FLPADdbJzRU=";
  };

  modRoot = "./go";
  subPackages = [ "cmd/dolt" ];
  vendorHash = "sha256-ksj5c4GvgddNqUKV+EwKVU/zA38vs6T/A2wr0YqwiCo=";
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
