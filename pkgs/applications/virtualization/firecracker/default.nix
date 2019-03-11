{ fetchurl, stdenv }:

let
  version = "0.15.0";
  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  fetchbin = name: sha256: fetchurl {
    url    = "${baseurl}/v${version}/${name}-v${version}";
    inherit sha256;
  };

  firecracker-bin = fetchbin "firecracker" "06b9pj9s4i0wqbh24frsza2j28n7qflp623vwvar5k18jq6jixd0";
  jailer-bin      = fetchbin "jailer"      "17nbsg3yi9rif9qxgp483b2qx0jn2sn1hlvk63gl8m54mnxzmcr3";
in
stdenv.mkDerivation {
  name = "firecracker-${version}";
  inherit version;

  srcs = [ firecracker-bin jailer-bin ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    install -D ${firecracker-bin} $out/bin/firecracker
    install -D ${jailer-bin}      $out/bin/jailer
  '';

  meta = with stdenv.lib; {
    description = "Secure, fast, minimal micro-container virtualization";
    homepage    = http://firecracker-microvm.io;
    license     = licenses.asl20;
    platforms   = [ "x86_64-linux" ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
