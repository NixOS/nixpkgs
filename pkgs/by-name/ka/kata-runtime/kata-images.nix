# Derived from https://github.com/colemickens/nixpkgs-kubernetes
{
  fetchzip,
  lib,
  version,
  zstd,
}:

let
  images = {
    x86_64-linux = {
      suffix = "amd64";
      hash = "sha256-qRCAGFQ7QrqsrL/+mNZc1kFUmR3LO+I3ueFCjvchfvc=";
    };
    aarch64-linux = {
      suffix = "arm64";
      hash = "sha256-Gosy1+kXiVyddgYNhvR1S0UXpFnmzQfxVGkbNkuJah8=";
    };
  };

  mkKataImages =
    { suffix, hash }:
    fetchzip {
      name = "kata-images-${version}";
      url = "https://github.com/kata-containers/kata-containers/releases/download/${version}/kata-static-${version}-${suffix}.tar.zst";
      inherit hash;
      nativeBuildInputs = [ zstd ];

      postFetch = ''
        mv $out/kata/share/kata-containers kata-containers
        rm -r $out
        mkdir -p $out/share
        mv kata-containers $out/share/kata-containers
      '';

      meta = {
        description = "Lightweight Virtual Machines like containers that provide the workload isolation and security of VMs";
        homepage = "https://github.com/kata-containers/kata-containers";
        changelog = "https://github.com/kata-containers/kata-containers/releases/tag/${version}";
        license = lib.licenses.asl20;
        maintainers = with lib.maintainers; [ thomasjm ];
        platforms = lib.attrNames images;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    };
in
lib.mapAttrs (_: mkKataImages) images
