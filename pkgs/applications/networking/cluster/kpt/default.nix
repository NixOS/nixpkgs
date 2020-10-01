{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x4g45sq8licjcccvad6w1yb9h2z2cc2xbpp073j1pafnqwmrswq";
  };

  vendorSha256 = "1vpljhqbvwv3a7k4c7p3n4ixh32f8hp9cqj8jz03mzqlmf60pyfs";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/GoogleContainerTools/kpt/run.version=${version}" ];

  meta = with lib; {
    description = "A toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
