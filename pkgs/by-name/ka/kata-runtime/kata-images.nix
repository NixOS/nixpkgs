# Derived from https://github.com/colemickens/nixpkgs-kubernetes
{
  fetchzip,
  lib,
  stdenv,
  version,
<<<<<<< HEAD
  zstd,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
      "x86_64-linux" = "sha256-roS2pGO00ORN+xxNU3/uqJG9RzhVqf8gCkt8EJJbY/g=";
      "aarch64-linux" = "sha256-AuK5a2Qtd176B91+vSsEFwuWICpe8wcGTbXoE7B8b20=";
=======
      "x86_64-linux" = "sha256-7xDc5Rr3rP36zS3kpM2QEqOCtmka3EAnts4Z1h8MNWY=";
      "aarch64-linux" = "sha256-8nLHTPetEfIrdtrpiT9Czcpf0NhL97TZ2DXyeBL04LA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
fetchzip {
  name = "kata-images-${version}";
<<<<<<< HEAD
  url = "https://github.com/kata-containers/kata-containers/releases/download/${version}/kata-static-${version}-${imageSuffix}.tar.zst";
  hash = imageHash;
  nativeBuildInputs = [ zstd ];
=======
  url = "https://github.com/kata-containers/kata-containers/releases/download/${version}/kata-static-${version}-${imageSuffix}.tar.xz";
  hash = imageHash;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
