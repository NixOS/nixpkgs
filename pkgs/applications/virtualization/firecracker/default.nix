{ fetchurl, lib, stdenv }:

let
  version = "0.23.0";

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
    x86_64-linux  = "11h6qkq55y1w0mlkfkbnpxxai73rzxkiz07i747m7a9azbrmldp8";
    aarch64-linux = "0zyx7md54w0fhqk1anfyjfdqrkg2mjyy17y9jk17p34yrw8j9y29";
  };

  jailer-bin = fetchbin "jailer" {
    x86_64-linux  = "15slr2azqvyqlhvlh7zk1n0rkfq282kj0pllp19r0yl1w8ns1gw5";
    aarch64-linux = "1d92jhd6fb7w7ciz15rcfp8jf74r2503w2fl1b6pznpc8h4qscfd";
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

  meta = with lib; {
    description = "Secure, fast, minimal micro-container virtualization";
    homepage    = "http://firecracker-microvm.io";
    license     = licenses.asl20;
    platforms   = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
