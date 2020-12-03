{ fetchurl, stdenv }:

let
  version = "0.21.3";

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
    x86_64-linux = "13mvdl7gk837w485vk0rrj084ids3nxs60014psg65vl7akwb9rr";
    aarch64-linux = "0s9gg6bz46yy0ix8s5wm1hcm420rh32ip3axa1by4rashgp804ka";
  };

  jailer-bin = fetchbin "jailer" {
    x86_64-linux = "0pyplam86arsc8mqhmmg47vin91b7nqpk3p6rnys3gs99mc1n5wm";
    aarch64-linux = "1h7x5828s09a393n8w4si7qclxngkw0d6zas3zmhviyr2xbjbz87";
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
