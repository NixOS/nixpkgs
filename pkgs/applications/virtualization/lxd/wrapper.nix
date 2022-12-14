{ lib
, makeWrapper
, acl
, rsync
, gnutar
, xz
, btrfs-progs
, gzip
, dnsmasq
, attr
, squashfsTools
, iproute2
, iptables
, writeShellScriptBin
, apparmor-profiles
, apparmor-parser
, criu
, bash
, nixosTests
, lxd-unwrapped
, symlinkJoin
}:
symlinkJoin {
  name = "lxd-${lxd-unwrapped.version}";

  paths = [ lxd-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
      wrapProgram $out/bin/lxd --prefix PATH : ${lib.makeBinPath (
      [ iptables ]
      ++ [ acl rsync gnutar xz btrfs-progs gzip dnsmasq squashfsTools iproute2 bash criu attr ]
      ++ [ (writeShellScriptBin "apparmor_parser" ''
             exec '${apparmor-parser}/bin/apparmor_parser' -I '${apparmor-profiles}/etc/apparmor.d' "$@"
           '') ]
      )
    }
  '';

  passthru.tests.lxd = nixosTests.lxd;
  passthru.tests.lxd-nftables = nixosTests.lxd-nftables;

  inherit (lxd-unwrapped) meta;
}
