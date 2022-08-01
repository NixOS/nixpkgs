{ lib, buildGoModule, fetchurl, nixosTests, openssl, pkg-config }:

buildGoModule rec {
  pname = "ipfs";
  version = "0.14.0"; # When updating, also check if the repo version changed and adjust repoVersion below
  rev = "v${version}";

  passthru.repoVersion = "12"; # Also update ipfs-migrator when changing the repo version

  # go-ipfs makes changes to it's source tarball that don't match the git source.
  src = fetchurl {
    url = "https://github.com/ipfs/kubo/releases/download/${rev}/kubo-source.tar.gz";
    hash = "sha256-93jd0r5nWkGrMnaPXoJMf6dHxMrtiWPgkHYaWH109lg=";
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

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];
  tags = [ "openssl" ];

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
