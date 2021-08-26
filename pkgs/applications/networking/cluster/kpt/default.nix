{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.38.1";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gJAdxg/evsQ+mKsNx/migDMK5lCZ2qSrksbsGDr4fmU=";
  };

  vendorSha256 = "sha256-GvkT51JudEdPz6zbqyf5qY6P2AbsaSMbirnxXmza5aI=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/GoogleContainerTools/kpt/run.version=${version}" ];

  meta = with lib; {
    description = "A toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
