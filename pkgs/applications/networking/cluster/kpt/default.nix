{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "kpt";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "GoogleContainerTools";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lvfbpxxddm1pk4mb4sm0chw15dalsfyhgy86npz94xjf1jssyh8";
  };

  vendorSha256 = "1xkjgzy9z7v5z4kl1769dgrrr0ljr0fdxfdj7xbic9hl6nm94kif";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A toolkit to help you manage, manipulate, customize, and apply Kubernetes Resource configuration data files";
    homepage = "https://googlecontainertools.github.io/kpt/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikefaille ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
