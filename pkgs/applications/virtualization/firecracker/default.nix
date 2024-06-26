{
  fetchurl,
  lib,
  stdenv,
}:

let
  version = "1.7.0";
  # nixpkgs-update: no auto update

  suffix =
    {
      x86_64-linux = "x86_64";
      aarch64-linux = "aarch64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  dlbin =
    sha256:
    fetchurl {
      url = "${baseurl}/v${version}/firecracker-v${version}-${suffix}.tgz";
      sha256 =
        sha256."${stdenv.hostPlatform.system}"
          or (throw "unsupported system ${stdenv.hostPlatform.system}");
    };

in
stdenv.mkDerivation {
  pname = "firecracker";
  inherit version;

  sourceRoot = ".";
  src = dlbin {
    x86_64-linux = "sha256-Vb0+bVmf3RCONuUvmu4jGfBsGKkPL6SbZOk/3wb1/1M=";
    aarch64-linux = "sha256-PLoQA4a6qulxSns/ZRSgn6EtHr46/hstNhP1pAHt9VA=";
  };

  dontConfigure = true;

  buildPhase = ''
    mv release-v${version}-${suffix}/firecracker-v${version}-${suffix} firecracker
    mv release-v${version}-${suffix}/jailer-v${version}-${suffix} jailer
    chmod +x firecracker jailer
  '';

  doCheck = true;
  checkPhase = ''
    ./firecracker --version
    ./jailer --version
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D firecracker $out/bin/firecracker
    install -D jailer      $out/bin/jailer
  '';

  meta = with lib; {
    description = "Secure, fast, minimal micro-container virtualization";
    homepage = "http://firecracker-microvm.io";
    changelog = "https://github.com/firecracker-microvm/firecracker/releases/tag/v${version}";
    mainProgram = "firecracker";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      thoughtpolice
      qjoly
    ];
  };
}
