{ fetchurl, stdenv }:

let
  version = "0.18.0";
  baseurl = "https://github.com/firecracker-microvm/firecracker/releases/download";

  fetchbin = name: sha256: fetchurl {
    url    = "${baseurl}/v${version}/${name}-v${version}";
    inherit sha256;
  };

  firecracker-bin = fetchbin "firecracker" "140g93z0k8yd9lr049ps4dj0psb9ac1v7g5zs7lzpws9rj8shmgh";
  jailer-bin      = fetchbin "jailer"      "0sk1zm1fx0zdy5il8vyygzads72ni2lcil42wv59j8b2bg8p7fwd";
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
