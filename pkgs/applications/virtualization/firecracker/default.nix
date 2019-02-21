{ fetchurl, stdenv }:

let
  version = "0.14.0";
  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  fetchbin = name: sha256: fetchurl {
    url    = "${baseurl}/v${version}/${name}-v${version}";
    inherit sha256;
  };

  firecracker-bin = fetchbin "firecracker" "02d7s2hzhl13k5linlav7yc4kg9v70sccc3ysfgaqq8hz7zfqywg";
  jailer-bin      = fetchbin "jailer"      "120n14zjnm21s39dza99p003bn5n0n5fzcyaw4l6laq336r24gvi";
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
