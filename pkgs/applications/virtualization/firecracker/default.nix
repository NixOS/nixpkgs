{ fetchurl, stdenv }:

let
  version = "0.22.0";

  suffix = {
    x86_64-linux  = "x86_64";
    aarch64-linux = "aarch64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";
  fetchbin = name: sha256: fetchurl {
    url    = "${baseurl}/v${version}/${name}-v${version}-${suffix}";
    sha256 = sha256."${stdenv.hostPlatform.system}";
  };

  firecracker-bin = fetchbin "firecracker" {
    x86_64-linux  = "1jl7cmw53fbykcji8a0bkdy82mgpfr8km3ab6iwsrswvahh4srx7";
    aarch64-linux = "15vi6441gr4jy0698ifashgv1ic7iz0kbm7c28m2jd8z08p6bnlz";
  };

  jailer-bin = fetchbin "jailer" {
    x86_64-linux  = "0wir7fi1iqvw02908axfaqzp9q5qyg4yk5jicp8s493iz3vhm9h7";
    aarch64-linux = "1l3yc9j27vxfyn89xmxi1ir635v7l8ikwpw9a30dhh50wa3rm4jy";
  };

in
stdenv.mkDerivation {
  pname = "firecracker";
  inherit version;
  srcs = [ firecracker-bin jailer-bin ];

  unpackPhase    = ":";
  configurePhase = ":";

  buildPhase     = ''
    cp ${firecracker-bin} firecracker
    cp ${jailer-bin}      jailer
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

  meta = with stdenv.lib; {
    description = "Secure, fast, minimal micro-container virtualization";
    homepage    = "http://firecracker-microvm.io";
    license     = licenses.asl20;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
