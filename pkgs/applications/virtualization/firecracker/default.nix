{ fetchurl, stdenv }:

let
  version = "0.20.0";

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
    x86_64-linux  = "073pp4q5dnyr126k8k7qdkqclqx18hj12app4gj2is0413gia8z9";
    aarch64-linux = "1w5f522imq5dnjrdidnrq7jlwcdrsiz32shv9bh66dhy336sd8qw";
  };

  jailer-bin = fetchbin "jailer" {
    x86_64-linux  = "0falk6y9y0pimgav1yg6ydn6wsslz0my01qd9by8ipk3f3776531";
    aarch64-linux = "1j4x4p4zz1ydvpzbbmxszyqv28qbl4v3hiwdj2f67f1jn1cv9l7z";
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
    homepage    = http://firecracker-microvm.io;
    license     = licenses.asl20;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
