{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "istioctl";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "istio";
    repo = "istio";
    rev = version;
    sha256 = "0xga0vjr2nfbxwbawly8vg9vnpavxbmc1agg2a3cp1ncmzfrgpcx";
  };
  vendorSha256 = "15l9z2a8p46jvmkl0vvm6s196mlics0qgmpm3yq3bn6cqnybdsij";

  subPackages = [ "istioctl/cmd/istioctl" ];

  meta = with lib; {
    description = "Istio configuration command line utility for service operators to debug and diagnose their Istio mesh";
    homepage = "https://istio.io/latest/docs/reference/commands/istioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
    platforms = platforms.unix;
  };
}
