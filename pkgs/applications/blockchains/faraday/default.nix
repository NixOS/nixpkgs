{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "faraday";
  version = "0.2.5-alpha";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "faraday";
    rev = "v${version}";
    sha256 = "16mz333a6awii6g46gr597j31jmgws4285s693q0b87fl1ggj2zz";
  };

  vendorSha256 = "1nclmvypxp5436q6qaagp1k5bfmaia7hsykw47va0pijlsvsbmck";

  subPackages = [ "cmd/frcli" "cmd/faraday" ];

  meta = with lib; {
    description = "LND Channel Management Tools";
    homepage = "https://github.com/lightninglabs/faraday";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags prusnak ];
  };
}
