{ nixpkgs ? <nixpkgs>
, system ? builtins.currentSystem
, minimal ? false
}:

with import ../lib/testing.nix { inherit system minimal; };

{
  avahi = makeTest (import ./avahi.nix);
  bittorrent = makeTest (import ./bittorrent.nix);
  firefox = makeTest (import ./firefox.nix);
  firewall = makeTest (import ./firewall.nix);
  installer = makeTests (import ./installer.nix);
  efi-installer = makeTests (import ./efi-installer.nix);
  gnome3 = makeTest (import ./gnome3.nix);
  ipv6 = makeTest (import ./ipv6.nix);
  jenkins = makeTest (import ./jenkins.nix);
  kde4 = makeTest (import ./kde4.nix);
  #kexec = makeTest (import ./kexec.nix);
  login = makeTest (import ./login.nix {});
  logstash = makeTest (import ./logstash.nix);
  latestKernel.login = makeTest (import ./login.nix ({ config, pkgs, ... }: { boot.kernelPackages = pkgs.linuxPackages_latest; }));
  misc = makeTest (import ./misc.nix);
  #mpich = makeTest (import ./mpich.nix);
  mysql = makeTest (import ./mysql.nix);
  mysql_replication = makeTest (import ./mysql-replication.nix);
  munin = makeTest (import ./munin.nix);
  nat = makeTest (import ./nat.nix);
  nfs3 = makeTest (import ./nfs.nix { version = 3; });
  #nfs4 = makeTest (import ./nfs.nix { version = 4; });
  openssh = makeTest (import ./openssh.nix);
  #partition = makeTest (import ./partition.nix);
  printing = makeTest (import ./printing.nix);
  proxy = makeTest (import ./proxy.nix);
  quake3 = makeTest (import ./quake3.nix);
  simple = makeTest (import ./simple.nix);
  #subversion = makeTest (import ./subversion.nix);
  tomcat = makeTest (import ./tomcat.nix);
  #trac = makeTest (import ./trac.nix);
  xfce = makeTest (import ./xfce.nix);
  runInMachine.test = import ./run-in-machine.nix { inherit system; };
}
