{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "assetfinder";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "assetfinder";
    rev = "v${version}";
    hash = "sha256-7+YF1VXBcFehKw9JzurmXNu8yeZPdqfQEuaqwtR4AuA=";
  };

  postPatch = ''
    go mod init github.com/tomnomnom/assetfinder
  '';

  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/tomnomnom/assetfinder";
    description = "Find domains and subdomains related to a given domain";
    mainProgram = "assetfinder";
    maintainers = with maintainers; [ shard7 ];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ fromSource binaryNativeCode ];
    license = with licenses; [ mit ];
  };
}
