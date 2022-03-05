{ lib, buildGoModule, fetchurl, nixosTests }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.12.0"; # When updating, also check if the repo version changed and adjust repoVersion below
  rev = "v${version}";

  repoVersion = "12"; # Also update ipfs-migrator when changing the repo version

  # go-ipfs makes changes to it's source tarball that don't match the git source.
  src = fetchurl {
    url = "https://github.com/ipfs/go-ipfs/releases/download/${rev}/go-ipfs-source.tar.gz";
    sha256 = "jWoMm/xIp3Zn/FiHWQ5/q39i6Lh4Fdoi9OdnRVc51Xk=";
  };

  # tarball contains multiple files/directories
  postUnpack = ''
    mkdir ipfs-src
    shopt -s extglob
    mv !(ipfs-src) ipfs-src || true
    cd ipfs-src
  '';

  sourceRoot = ".";

  subPackages = [ "cmd/ipfs" ];

  passthru.tests.ipfs = nixosTests.ipfs;

  vendorSha256 = null;

  postInstall = ''
    install --mode=444 -D misc/systemd/ipfs.service $out/etc/systemd/system/ipfs.service
    install --mode=444 -D misc/systemd/ipfs-hardened.service $out/etc/systemd/system/ipfs-hardened.service
    install --mode=444 -D misc/systemd/ipfs-api.socket $out/etc/systemd/system/ipfs-api.socket
    install --mode=444 -D misc/systemd/ipfs-gateway.socket $out/etc/systemd/system/ipfs-gateway.socket
    substituteInPlace $out/etc/systemd/system/ipfs.service \
      --replace /usr/bin/ipfs $out/bin/ipfs
    substituteInPlace $out/etc/systemd/system/ipfs-hardened.service \
      --replace /usr/bin/ipfs $out/bin/ipfs
  '';

  meta = with lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
