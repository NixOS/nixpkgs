{
  lib,
  stdenv,
  fetchurl,
  libpcap,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "p0f";
  version = "3.09b";

  src = fetchurl {
    url = "http://lcamtuf.coredump.cx/p0f3/releases/${pname}-${version}.tgz";
    sha256 = "0zqfq3gdnha29ckvlqmyp36c0jhj7f69bhqqx31yb6vkirinhfsl";
  };

  buildInputs = [ libpcap ];

  patches = [ ./build-stdio.patch ];

  buildPhase = ''
    substituteInPlace config.h --replace "p0f.fp" "$out/etc/p0f.fp"
    substituteInPlace build.sh --replace "/bin/bash" "${bash}/bin/bash"
    ./build.sh
    cd tools && make && cd ..
  '';

  installPhase = ''
    mkdir -p $out/sbin $out/etc

    cp ./p0f                $out/sbin
    cp ./p0f.fp             $out/etc

    cp ./tools/p0f-client   $out/sbin
    cp ./tools/p0f-sendsyn  $out/sbin
    cp ./tools/p0f-sendsyn6 $out/sbin
  '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "Passive network reconnaissance and fingerprinting tool";
    homepage = "https://lcamtuf.coredump.cx/p0f3/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
