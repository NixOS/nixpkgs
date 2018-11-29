{ fetchurl, stdenv }:

let
  version = "0.12.0";
  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  fetchbin = name: sha256: fetchurl {
    url    = "${baseurl}/v${version}/${name}-v${version}";
    inherit sha256;
  };

  firecracker-bin = fetchbin "firecracker" "0jk9w5kagqp3w668c1x0g4yyahmy7696pm0bkhv066rrdpcqpw66";
  jailer-bin      = fetchbin "jailer"      "1fcxzpnapnccklgbi4bis3f6c9fki2daxvzg9l7433vfqz2zbyjl";
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
