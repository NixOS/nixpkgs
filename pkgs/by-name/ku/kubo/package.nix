{ lib
, buildGoModule
, fetchurl
, nixosTests
, callPackage
}:

buildGoModule rec {
  pname = "kubo";
  version = "0.26.0"; # When updating, also check if the repo version changed and adjust repoVersion below
  rev = "v${version}";

  passthru.repoVersion = "15"; # Also update kubo-migrator when changing the repo version

  # Kubo makes changes to its source tarball that don't match the git source.
  src = fetchurl {
    url = "https://github.com/ipfs/kubo/releases/download/${rev}/kubo-source.tar.gz";
    hash = "sha256-qvn5VqEPLkehFWamtPGRuDLJ06bd5bn1qZRp05jP2AY=";
  };

  # tarball contains multiple files/directories
  postUnpack = ''
    mkdir kubo-src
    shopt -s extglob
    mv !(kubo-src) kubo-src || true
    cd kubo-src
  '';

  sourceRoot = ".";

  subPackages = [ "cmd/ipfs" ];

  passthru.tests = {
    inherit (nixosTests) kubo;
    repoVersion = callPackage ./test-repoVersion.nix {};
  };

  vendorHash = null;

  outputs = [ "out" "systemd_unit" "systemd_unit_hardened" ];

  postPatch = ''
    substituteInPlace 'misc/systemd/ipfs.service' \
      --replace '/usr/local/bin/ipfs' "$out/bin/ipfs"
    substituteInPlace 'misc/systemd/ipfs-hardened.service' \
      --replace '/usr/local/bin/ipfs' "$out/bin/ipfs"
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
    description = "An IPFS implementation in Go";
    homepage = "https://ipfs.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "ipfs";
    maintainers = with maintainers; [ Luflosi fpletz ];
  };
}
