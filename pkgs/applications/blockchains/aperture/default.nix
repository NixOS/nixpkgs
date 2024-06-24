{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "aperture";
  version = "0.3-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "aperture";
    rev = "v${version}";
    hash = "sha256-PsmaNJxWkXiFDA7IGhT+Kx1GUvv23c8L8Jz21/b48oo=";
  };

  vendorHash = "sha256-rrDLdE7c6ykhdqOfRpuxyRO4xqYp3LZvovAppzy1wVw=";

  subPackages = [ "cmd/aperture" ];

  meta = with lib; {
    description = "L402 (Lightning HTTP 402) Reverse Proxy";
    homepage = "https://github.com/lightninglabs/aperture";
    license = licenses.mit;
    maintainers = with maintainers; [ sputn1ck HannahMR ];
    mainProgram = "aperture";
  };
}
