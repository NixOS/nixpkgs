{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cirrusgo";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Ph33rr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FYI/Ldu91YB/4wCiVADeYxYQOeBGro1msY5VXsnixw4=";
  };

  vendorHash = "sha256-KCf2KQ8u+nX/+zMGZ6unWb/Vz6zPNkKtMioFo1FlnVI=";

  meta = with lib; {
    description = "Tool to scan SAAS and PAAS applications";
    mainProgram = "cirrusgo";
    homepage = "https://github.com/Ph33rr/cirrusgo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
