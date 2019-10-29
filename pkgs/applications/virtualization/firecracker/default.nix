{ fetchurl, stdenv }:

let
  version = "0.19.0";
  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  fetchbin = name: sha256: fetchurl {
    url    = "${baseurl}/v${version}/${name}-v${version}";
    inherit sha256;
  };

  firecracker-bin = fetchbin "firecracker" "0yjhw77xc2nc96p36jhf0va95gf6hwi9n270g4iiwakycdy048mx";
  jailer-bin      = fetchbin "jailer"      "1q792b4bl1q3ach8nc8l0fbcil44knv3wa542xrskndzdz28lhsp";
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
    platforms   = [ "x86_64-linux" ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
