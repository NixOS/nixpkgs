{ fetchurl, lib, stdenv }:

let
  version = "0.24.3";

  suffix = {
    x86_64-linux  = "x86_64";
    aarch64-linux = "aarch64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  dlbin = sha256: fetchurl {
    url    = "${baseurl}/v${version}/firecracker-v${version}-${suffix}.tgz";
    sha256 = sha256."${stdenv.hostPlatform.system}";
  };

in
stdenv.mkDerivation {
  pname = "firecracker";
  inherit version;

  sourceRoot = ".";
  src = dlbin {
    x86_64-linux  = "sha256-i6NMVFoLm4hQJH7RnhfC0t+0DJCINoP5b/iCv9JyRdk=";
    aarch64-linux = "0m7xs12g97z1ipzaf7dgknf3azlah0p6bdr9i454azvzg955238b";
  };

  dontConfigure = true;

  buildPhase     = ''
    mv firecracker-* firecracker
    mv jailer-*      jailer
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
    homepage    = "http://firecracker-microvm.io";
    license     = licenses.asl20;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
