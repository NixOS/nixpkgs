{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "aperture";
  version = "0.2-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "aperture";
    rev = "v${version}";
    hash = "sha256-l1fpjCAg+1PGNotKrjFLoYOMEzRNXC1mfdjRPfE0DsY=";
  };

  vendorHash = "sha256-tWFFmRSDUZXijAUTgR8k4EERHwIEBOyZZZ9BGXso/tU=";

  subPackages = [ "cmd/aperture" ];

  meta = with lib; {
    description = "L402 (Lightning HTTP 402) Reverse Proxy";
    homepage = "https://github.com/lightninglabs/aperture";
    license = licenses.mit;
    maintainers = with maintainers; [ sputn1ck ];
    mainProgram = "aperture";
  };
}
