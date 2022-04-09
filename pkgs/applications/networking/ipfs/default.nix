{ lib, buildGoModule, fetchurl, nixosTests }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.12.1"; # When updating, also check if the repo version changed and adjust repoVersion below
  rev = "v${version}";

  repoVersion = "12"; # Also update ipfs-migrator when changing the repo version

  # go-ipfs makes changes to it's source tarball that don't match the git source.
  src = fetchurl {
    url = "https://github.com/ipfs/go-ipfs/releases/download/${rev}/go-ipfs-source.tar.gz";
    sha256 = "sha256-fUExCvE6x5VFBl66y52DGvr8ZNSXZ6MYpVQP/D7X328=";
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

  outputs = [ "out" "systemd_unit" "systemd_unit_hardened" ];

  postPatch = ''
    substituteInPlace 'misc/systemd/ipfs.service' \
      --replace '/usr/bin/ipfs' "$out/bin/ipfs"
    substituteInPlace 'misc/systemd/ipfs-hardened.service' \
      --replace '/usr/bin/ipfs' "$out/bin/ipfs"
  '';

  postInstall = ''
    install --mode=444 -D 'misc/systemd/ipfs-api.socket' "$systemd_unit/etc/systemd/system/ipfs-api.socket"
    install --mode=444 -D 'misc/systemd/ipfs-gateway.socket' "$systemd_unit/etc/systemd/system/ipfs-gateway.socket"
    install --mode=444 -D 'misc/systemd/ipfs.service' "$systemd_unit/etc/systemd/system/ipfs.service"

    install --mode=444 -D 'misc/systemd/ipfs-api.socket' "$systemd_unit_hardened/etc/systemd/system/ipfs-api.socket"
    install --mode=444 -D 'misc/systemd/ipfs-gateway.socket' "$systemd_unit_hardened/etc/systemd/system/ipfs-gateway.socket"
    install --mode=444 -D 'misc/systemd/ipfs-hardened.service' "$systemd_unit_hardened/etc/systemd/system/ipfs.service"
  '';

  meta = with lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
