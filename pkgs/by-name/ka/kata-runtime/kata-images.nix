# Derived from https://github.com/colemickens/nixpkgs-kubernetes
{
  fetchzip,
  lib,
  stdenv,
  version,
  zstd,
}:

let
  imageSuffix =
    {
      "x86_64-linux" = "amd64";
      "aarch64-linux" = "arm64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  imageHash =
    {
      "x86_64-linux" = "sha256-ea4/6xjuoiqFebGF+NegGa4B+3Imf/4uULfQbJxqKtc=";
      "aarch64-linux" = "sha256-cPx6uHXyMZ0x56dLUKx91FjhgkJaYW0nUtLrnfHz0as=";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
fetchzip {
  name = "kata-images-${version}";
  url = "https://github.com/kata-containers/kata-containers/releases/download/${version}/kata-static-${version}-${imageSuffix}.tar.zst";
  hash = imageHash;
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
