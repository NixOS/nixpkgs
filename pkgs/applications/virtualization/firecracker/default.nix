{ fetchurl, stdenv }:

let
  version = "0.15.2";
  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  fetchbin = name: sha256: fetchurl {
    url    = "${baseurl}/v${version}/${name}-v${version}";
    inherit sha256;
  };

  firecracker-bin = fetchbin "firecracker" "11g0iz1krsm6gzhvf0fb4101c6qyk6bl8j3kjidbb52x9i4aqsxk";
  jailer-bin      = fetchbin "jailer"      "0j1gc1cdsfsi82fkvvxla25791lcvk6vmp46i82f0ms9xm7xhswz";
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
