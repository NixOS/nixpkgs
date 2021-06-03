{ fetchFromGitHub, buildGoModule, lib, stdenv }:

buildGoModule rec {
  pname = "hydra";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "hydra";
    rev = "v${version}";
    sha256 = "01q4ihhf06iyk84ssnz9r479zg5n9bnj58pv8fcfjm9ai1mvb1il";
  };

  vendorSha256 = "1ba2g2fzhpml5b8kz2y15ng83l7884mzn6rl1qj4dlwz6vhhx6qq";

  subPackages = [ "." ];

  buildFlags = [ "-tags sqlite" ];

  doCheck = false;

  preBuild = ''
    # patchShebangs doesn't work for this Makefile, do it manually
    substituteInPlace Makefile --replace '/bin/bash' '${stdenv.shell}'
  '';

  meta = with lib; {
    maintainers = with maintainers; [ cmcdragonkai ];
    homepage = "https://www.ory.sh/hydra/";
    license = licenses.asl20;
    description = "OpenID Certified OAuth 2.0 Server and OpenID Connect Provider optimized for low-latency, high throughput, and low resource consumption";
  };
}
