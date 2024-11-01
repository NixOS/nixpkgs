{ stdenv
, lib
, fetchFromGitHub
, vmnet
}:
stdenv.mkDerivation rec {
  pname = "socket_vmnet";
  version = "1.1.4";

  buildInputs = [ vmnet ];

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "socket_vmnet";
    rev = "v${version}";
    hash = "sha256-VC5l9hMFqcdsSuQg2UYP1QFPRByQtoI0jmrLfD7Io/E=";
  };

  preConfigure = ''
    export DESTDIR=$out
    export PREFIX=/
    export VERSION=${src.rev}
  '';

  installPhase = ''
    mkdir $out
    make install.bin
  '';

  meta = with lib; {
    description = "vmnet.framework support for unmodified rootless QEMU";
    homepage = "https://github.com/lima-vm/socket_vmnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ sysedwinistrator ];
    platforms = platforms.darwin;
  };
}
