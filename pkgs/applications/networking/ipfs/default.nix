{ stdenv, buildGoModule, fetchurl, nixosTests }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.6.0";
  rev = "v${version}";

  # go-ipfs makes changes to it's source tarball that don't match the git source.
  src = fetchurl {
    url = "https://github.com/ipfs/go-ipfs/releases/download/${rev}/go-ipfs-source.tar.gz";
    sha256 = "14bgq2j2bjjy0pspy2lsj5dm3w9rmfha0l8kyq5ig86yhc4nzn80";
  };

  # tarball contains multiple files/directories
  postUnpack = ''
    mkdir ipfs-src
    mv * ipfs-src || true
    cd ipfs-src
  '';

  sourceRoot = ".";

  subPackages = [ "cmd/ipfs" ];

  passthru.tests.ipfs = nixosTests.ipfs;

  vendorSha256 = null;

  postInstall = ''
    install -D misc/systemd/ipfs.service $out/etc/systemd/system/ipfs.service
    install -D misc/systemd/ipfs-api.socket $out/etc/systemd/system/ipfs-api.socket
    install -D misc/systemd/ipfs-gateway.socket $out/etc/systemd/system/ipfs-gateway.socket
    substituteInPlace $out/etc/systemd/system/ipfs.service \
      --replace /usr/bin/ipfs $out/bin/ipfs
  '';

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
