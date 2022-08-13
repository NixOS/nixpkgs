{ fetchurl, lib, stdenv }:

let
  version = "1.1.1";

  suffix = {
    x86_64-linux = "x86_64";
    aarch64-linux = "aarch64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  dlbin = sha256: fetchurl {
    url = "${baseurl}/v${version}/firecracker-v${version}-${suffix}.tgz";
    sha256 = sha256."${stdenv.hostPlatform.system}";
  };

in
stdenv.mkDerivation {
  pname = "firecracker";
  inherit version;

  sourceRoot = ".";
  src = dlbin {
    x86_64-linux = "sha256-KRlOE4iDWMYzKZUZnuKIwIGooj5o8ARpROS7f2VIr1c=";
    aarch64-linux = "sha256-AqVFqUbMtjPmOsSgAaJ2AFNc0McC708fAD36qLz0VAc=";
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
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ thoughtpolice endocrimes ];
  };
}
