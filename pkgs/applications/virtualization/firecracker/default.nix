{ fetchurl, lib, stdenv }:

let
  arch = {
    x86_64-linux = "x86_64";
    aarch64-linux = "aarch64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  
  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";
  dlhashByVersion = {
    "0.24.5" = builtins.getAttr arch {
      x86_64 = "sha256-drcm2kz2csuJqr8Oqs0r1BrxgPHOyuwC2S+99MhbMjA=";
      aarch64 = "sha256-x8RoBmgY3HRUOLw8YzEwQfQuT83zGfBHHWu88b4i05o=";
    };
    "0.25.2" = builtins.getAttr arch {
      x86_64 = "sha256-ZzlPq+Q9XfWQJr+7nKS0e6bfKwYNfpMHSiBIKeOr/s4=";
      aarch64 = "sha256-75UC+HeVUfUk1HRvTJsOHbHHkgr6me1OtxDF7lahf68=";
    };
  };
  dlbin = version: hash: fetchurl {
    url = "${baseurl}/v${version}/firecracker-v${version}-${arch}.tgz";
    sha256 = hash;
  };

in
stdenv.mkDerivation rec {
  pname = "firecracker";
  version = "0.25.2";
  dlhash = builtins.getAttr version dlhashByVersion;

  sourceRoot = ".";
  src = dlbin version dlhash;

  dontConfigure = true;

  buildPhase = ''
    mv release-v${version}*/firecracker-v${version}-${arch} firecracker
    mv release-v${version}*/jailer-v${version}-${arch} jailer
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
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ thoughtpolice endocrimes ];
  };
}
