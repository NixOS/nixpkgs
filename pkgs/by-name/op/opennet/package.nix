# OpenNet — peer-to-peer network for distributed computing on a LAN.
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "opennet";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "aiv-tmc";
    repo = "opennet";
    rev = version;
    hash = "sha256-jGrpdoO6LRGCkKt6EE/ONxWYVJWGbTnJEt9LPmveJ6I=";
  };

  cargoHash = "sha256-2W/iPej/WCrNETvDVaMKQgL3uX5Q64DxtCTOZmlgVmU=";

  doCheck = true;

  __structuredAttrs = true;

  postInstall = ''
    install -Dm644 init/opennetd.service     $out/lib/systemd/system/opennetd.service
    install -Dm644 opennet.sysusers            $out/lib/sysusers.d/opennet.conf
    install -Dm644 opennet.tmpfiles            $out/lib/tmpfiles.d/opennet.conf

    install -d $out/share/opennet/init
    install -Dm644 init/opennetd.dinit         $out/share/opennet/init/opennetd.dinit
    install -Dm755 init/opennetd.openrc        $out/share/opennet/init/opennetd.openrc
    install -Dm755 init/opennetd.run           $out/share/opennet/init/opennetd.run

    install -Dm644 README.md                   $out/share/doc/opennet/README.md
    install -Dm644 docs/ARCHITECTURE.md        $out/share/doc/opennet/ARCHITECTURE.md
    install -Dm644 docs/PROTOCOL.md            $out/share/doc/opennet/PROTOCOL.md
    install -Dm644 docs/OPERATIONS.md          $out/share/doc/opennet/OPERATIONS.md
    install -Dm644 docs/SWARM.md               $out/share/doc/opennet/SWARM.md
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Peer-to-peer network for distributed computing on a LAN";
    longDescription = ''
      OpenNet turns a group of machines into a shared compute pool governed
      by a trust coefficient: nodes earn trust by donating CPU/GPU time and
      spend it to run their own work on other machines. Includes LAN
      multicast discovery, WAN seed gossip, countersigned billing receipts,
      sandboxed task execution and an opt-in sharded "swarm" mode for
      running one shared program across consenting nodes.
    '';
    homepage = "https://github.com/aiv-tmc/opennet";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "opennetctl";
    platforms = lib.platforms.linux;
  };
}
