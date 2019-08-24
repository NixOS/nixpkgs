{ system, pkgs, callTest }:
# The return value of this function will be an attrset with arbitrary depth and
# the `anything` returned by callTest at its test leafs.
# The tests not supported by `system` will be replaced with `{}`, so that
# `passthru.tests` can contain links to those without breaking on architectures
# where said tests are unsupported.
# Example callTest that just extracts the derivation from the test:
#   callTest = t: t.test;

with pkgs.lib;

let
  discoverTests = val:
    if !isAttrs val then val
    else if hasAttr "test" val then callTest val
    else mapAttrs (n: s: discoverTests s) val;
  handleTest = path: args:
    discoverTests (import path ({ inherit system pkgs; } // args));
  handleTestOn = systems: path: args:
    if elem system systems then handleTest path args
    else {};
in
{
  acme = handleTestOn ["x86_64-linux"] ./acme.nix {};
  atd = handleTest ./atd.nix {};
  automysqlbackup = handleTest ./automysqlbackup.nix {};
  avahi = handleTest ./avahi.nix {};
  bcachefs = handleTestOn ["x86_64-linux"] ./bcachefs.nix {}; # linux-4.18.2018.10.12 is unsupported on aarch64
  beanstalkd = handleTest ./beanstalkd.nix {};
  beegfs = handleTestOn ["x86_64-linux"] ./beegfs.nix {}; # beegfs is unsupported on aarch64
  bind = handleTest ./bind.nix {};
  bittorrent = handleTest ./bittorrent.nix {};
  #blivet = handleTest ./blivet.nix {};   # broken since 2017-07024
  boot = handleTestOn ["x86_64-linux"] ./boot.nix {}; # syslinux is unsupported on aarch64
  boot-stage1 = handleTest ./boot-stage1.nix {};
  borgbackup = handleTest ./borgbackup.nix {};
  buildbot = handleTest ./buildbot.nix {};
  cadvisor = handleTestOn ["x86_64-linux"] ./cadvisor.nix {};
  cassandra = handleTest ./cassandra.nix {};
  ceph = handleTestOn ["x86_64-linux"] ./ceph.nix {};
  certmgr = handleTest ./certmgr.nix {};
  cfssl = handleTestOn ["x86_64-linux"] ./cfssl.nix {};
  chromium = (handleTestOn ["x86_64-linux"] ./chromium.nix {}).stable or {};
  cjdns = handleTest ./cjdns.nix {};
  clickhouse = handleTest ./clickhouse.nix {};
  cloud-init = handleTest ./cloud-init.nix {};
  codimd = handleTest ./codimd.nix {};
  colord = handleTest ./colord.nix {};
  containers-bridge = handleTest ./containers-bridge.nix {};
  containers-ephemeral = handleTest ./containers-ephemeral.nix {};
  containers-extra_veth = handleTest ./containers-extra_veth.nix {};
  containers-hosts = handleTest ./containers-hosts.nix {};
  containers-imperative = handleTest ./containers-imperative.nix {};
  containers-ipv4 = handleTest ./containers-ipv4.nix {};
  containers-ipv6 = handleTest ./containers-ipv6.nix {};
  containers-macvlans = handleTest ./containers-macvlans.nix {};
  containers-physical_interfaces = handleTest ./containers-physical_interfaces.nix {};
  containers-restart_networking = handleTest ./containers-restart_networking.nix {};
  containers-tmpfs = handleTest ./containers-tmpfs.nix {};
  couchdb = handleTest ./couchdb.nix {};
  deluge = handleTest ./deluge.nix {};
  dhparams = handleTest ./dhparams.nix {};
  dnscrypt-proxy = handleTestOn ["x86_64-linux"] ./dnscrypt-proxy.nix {};
  docker = handleTestOn ["x86_64-linux"] ./docker.nix {};
  docker-containers = handleTestOn ["x86_64-linux"] ./docker-containers.nix {};
  docker-edge = handleTestOn ["x86_64-linux"] ./docker-edge.nix {};
  docker-preloader = handleTestOn ["x86_64-linux"] ./docker-preloader.nix {};
  docker-registry = handleTest ./docker-registry.nix {};
  docker-tools = handleTestOn ["x86_64-linux"] ./docker-tools.nix {};
  docker-tools-overlay = handleTestOn ["x86_64-linux"] ./docker-tools-overlay.nix {};
  documize = handleTest ./documize.nix {};
  dovecot = handleTest ./dovecot.nix {};
  # ec2-config doesn't work in a sandbox as the simulated ec2 instance needs network access
  #ec2-config = (handleTestOn ["x86_64-linux"] ./ec2.nix {}).boot-ec2-config or {};
  ec2-nixops = (handleTestOn ["x86_64-linux"] ./ec2.nix {}).boot-ec2-nixops or {};
  ecryptfs = handleTest ./ecryptfs.nix {};
  ejabberd = handleTest ./xmpp/ejabberd.nix {};
  elk = handleTestOn ["x86_64-linux"] ./elk.nix {};
  env = handleTest ./env.nix {};
  etcd = handleTestOn ["x86_64-linux"] ./etcd.nix {};
  etcd-cluster = handleTestOn ["x86_64-linux"] ./etcd-cluster.nix {};
  ferm = handleTest ./ferm.nix {};
  firefox = handleTest ./firefox.nix {};
  firewall = handleTest ./firewall.nix {};
  fish = handleTest ./fish.nix {};
  flannel = handleTestOn ["x86_64-linux"] ./flannel.nix {};
  flatpak = handleTest ./flatpak.nix {};
  flatpak-builder = handleTest ./flatpak-builder.nix {};
  fluentd = handleTest ./fluentd.nix {};
  fsck = handleTest ./fsck.nix {};
  fwupd = handleTestOn ["x86_64-linux"] ./fwupd.nix {}; # libsmbios is unsupported on aarch64
  gdk-pixbuf = handleTest ./gdk-pixbuf.nix {};
  gitea = handleTest ./gitea.nix {};
  gitlab = handleTest ./gitlab.nix {};
  gitolite = handleTest ./gitolite.nix {};
  gjs = handleTest ./gjs.nix {};
  glusterfs = handleTest ./glusterfs.nix {};
  gnome3-xorg = handleTest ./gnome3-xorg.nix {};
  gnome3 = handleTest ./gnome3.nix {};
  gocd-agent = handleTest ./gocd-agent.nix {};
  gocd-server = handleTest ./gocd-server.nix {};
  google-oslogin = handleTest ./google-oslogin {};
  graphene = handleTest ./graphene.nix {};
  grafana = handleTest ./grafana.nix {};
  graphite = handleTest ./graphite.nix {};
  graylog = handleTest ./graylog.nix {};
  hadoop.hdfs = handleTestOn [ "x86_64-linux" ] ./hadoop/hdfs.nix {};
  hadoop.yarn = handleTestOn [ "x86_64-linux" ] ./hadoop/yarn.nix {};
  handbrake = handleTestOn ["x86_64-linux"] ./handbrake.nix {};
  haproxy = handleTest ./haproxy.nix {};
  hardened = handleTest ./hardened.nix {};
  hibernate = handleTest ./hibernate.nix {};
  hitch = handleTest ./hitch {};
  hocker-fetchdocker = handleTest ./hocker-fetchdocker {};
  home-assistant = handleTest ./home-assistant.nix {};
  hound = handleTest ./hound.nix {};
  hydra = handleTest ./hydra {};
  i3wm = handleTest ./i3wm.nix {};
  icingaweb2 = handleTest ./icingaweb2.nix {};
  iftop = handleTest ./iftop.nix {};
  incron = handleTest ./incron.nix {};
  influxdb = handleTest ./influxdb.nix {};
  initrd-network-ssh = handleTest ./initrd-network-ssh {};
  initrdNetwork = handleTest ./initrd-network.nix {};
  installer = handleTest ./installer.nix {};
  ipv6 = handleTest ./ipv6.nix {};
  jackett = handleTest ./jackett.nix {};
  jellyfin = handleTest ./jellyfin.nix {};
  jenkins = handleTest ./jenkins.nix {};
  jormungandr = handleTest ./jormungandr.nix {};
  kafka = handleTest ./kafka.nix {};
  kerberos = handleTest ./kerberos/default.nix {};
  kernel-latest = handleTest ./kernel-latest.nix {};
  kernel-lts = handleTest ./kernel-lts.nix {};
  kernel-testing = handleTest ./kernel-testing.nix {};
  keymap = handleTest ./keymap.nix {};
  knot = handleTest ./knot.nix {};
  kubernetes.dns = handleTestOn ["x86_64-linux"] ./kubernetes/dns.nix {};
  # kubernetes.e2e should eventually replace kubernetes.rbac when it works
  #kubernetes.e2e = handleTestOn ["x86_64-linux"] ./kubernetes/e2e.nix {};
  kubernetes.rbac = handleTestOn ["x86_64-linux"] ./kubernetes/rbac.nix {};
  latestKernel.login = handleTest ./login.nix { latestKernel = true; };
  ldap = handleTest ./ldap.nix {};
  leaps = handleTest ./leaps.nix {};
  libxmlb = handleTest ./libxmlb.nix {};
  lidarr = handleTest ./lidarr.nix {};
  lightdm = handleTest ./lightdm.nix {};
  limesurvey = handleTest ./limesurvey.nix {};
  login = handleTest ./login.nix {};
  loki = handleTest ./loki.nix {};
  #logstash = handleTest ./logstash.nix {};
  mailcatcher = handleTest ./mailcatcher.nix {};
  mathics = handleTest ./mathics.nix {};
  matrix-synapse = handleTest ./matrix-synapse.nix {};
  mediawiki = handleTest ./mediawiki.nix {};
  memcached = handleTest ./memcached.nix {};
  mesos = handleTest ./mesos.nix {};
  metabase = handleTest ./metabase.nix {};
  miniflux = handleTest ./miniflux.nix {};
  minio = handleTest ./minio.nix {};
  misc = handleTest ./misc.nix {};
  mongodb = handleTest ./mongodb.nix {};
  morty = handleTest ./morty.nix {};
  mosquitto = handleTest ./mosquitto.nix {};
  mpd = handleTest ./mpd.nix {};
  mumble = handleTest ./mumble.nix {};
  munin = handleTest ./munin.nix {};
  mutableUsers = handleTest ./mutable-users.nix {};
  mxisd = handleTest ./mxisd.nix {};
  mysql = handleTest ./mysql.nix {};
  mysqlBackup = handleTest ./mysql-backup.nix {};
  mysqlReplication = handleTest ./mysql-replication.nix {};
  nat.firewall = handleTest ./nat.nix { withFirewall = true; };
  nat.firewall-conntrack = handleTest ./nat.nix { withFirewall = true; withConntrackHelpers = true; };
  nat.standalone = handleTest ./nat.nix { withFirewall = false; };
  ndppd = handleTest ./ndppd.nix {};
  neo4j = handleTest ./neo4j.nix {};
  nesting = handleTest ./nesting.nix {};
  netdata = handleTest ./netdata.nix {};
  networking.networkd = handleTest ./networking.nix { networkd = true; };
  networking.scripted = handleTest ./networking.nix { networkd = false; };
  # TODO: put in networking.nix after the test becomes more complete
  networkingProxy = handleTest ./networking-proxy.nix {};
  nextcloud = handleTest ./nextcloud {};
  nexus = handleTest ./nexus.nix {};
  nfs3 = handleTest ./nfs.nix { version = 3; };
  nfs4 = handleTest ./nfs.nix { version = 4; };
  nghttpx = handleTest ./nghttpx.nix {};
  nginx = handleTest ./nginx.nix {};
  nginx-sso = handleTest ./nginx-sso.nix {};
  nix-ssh-serve = handleTest ./nix-ssh-serve.nix {};
  nixos-generate-config = handleTest ./nixos-generate-config.nix {};
  novacomd = handleTestOn ["x86_64-linux"] ./novacomd.nix {};
  nsd = handleTest ./nsd.nix {};
  nzbget = handleTest ./nzbget.nix {};
  openldap = handleTest ./openldap.nix {};
  opensmtpd = handleTest ./opensmtpd.nix {};
  openssh = handleTest ./openssh.nix {};
  # openstack-image-userdata doesn't work in a sandbox as the simulated openstack instance needs network access
  #openstack-image-userdata = (handleTestOn ["x86_64-linux"] ./openstack-image.nix {}).userdata or {};
  openstack-image-metadata = (handleTestOn ["x86_64-linux"] ./openstack-image.nix {}).metadata or {};
  osquery = handleTest ./osquery.nix {};
  osrm-backend = handleTest ./osrm-backend.nix {};
  ostree = handleTest ./ostree.nix {};
  overlayfs = handleTest ./overlayfs.nix {};
  packagekit = handleTest ./packagekit.nix {};
  pam-oath-login = handleTest ./pam-oath-login.nix {};
  pam-u2f = handleTest ./pam-u2f.nix {};
  pantheon = handleTest ./pantheon.nix {};
  paperless = handleTest ./paperless.nix {};
  peerflix = handleTest ./peerflix.nix {};
  pgjwt = handleTest ./pgjwt.nix {};
  pgmanage = handleTest ./pgmanage.nix {};
  php-pcre = handleTest ./php-pcre.nix {};
  plasma5 = handleTest ./plasma5.nix {};
  plotinus = handleTest ./plotinus.nix {};
  postgis = handleTest ./postgis.nix {};
  postgresql = handleTest ./postgresql.nix {};
  postgresql-wal-receiver = handleTest ./postgresql-wal-receiver.nix {};
  powerdns = handleTest ./powerdns.nix {};
  predictable-interface-names = handleTest ./predictable-interface-names.nix {};
  printing = handleTest ./printing.nix {};
  prometheus = handleTest ./prometheus.nix {};
  prometheus2 = handleTest ./prometheus-2.nix {};
  prometheus-exporters = handleTest ./prometheus-exporters.nix {};
  prosody = handleTest ./xmpp/prosody.nix {};
  prosodyMysql = handleTest ./xmpp/prosody-mysql.nix {};
  proxy = handleTest ./proxy.nix {};
  quagga = handleTest ./quagga.nix {};
  quake3 = handleTest ./quake3.nix {};
  rabbitmq = handleTest ./rabbitmq.nix {};
  radarr = handleTest ./radarr.nix {};
  radicale = handleTest ./radicale.nix {};
  redmine = handleTest ./redmine.nix {};
  roundcube = handleTest ./roundcube.nix {};
  rspamd = handleTest ./rspamd.nix {};
  rss2email = handleTest ./rss2email.nix {};
  rsyslogd = handleTest ./rsyslogd.nix {};
  runInMachine = handleTest ./run-in-machine.nix {};
  rxe = handleTest ./rxe.nix {};
  samba = handleTest ./samba.nix {};
  sddm = handleTest ./sddm.nix {};
  signal-desktop = handleTest ./signal-desktop.nix {};
  simple = handleTest ./simple.nix {};
  slim = handleTest ./slim.nix {};
  slurm = handleTest ./slurm.nix {};
  smokeping = handleTest ./smokeping.nix {};
  snapper = handleTest ./snapper.nix {};
  solr = handleTest ./solr.nix {};
  sonarr = handleTest ./sonarr.nix {};
  strongswan-swanctl = handleTest ./strongswan-swanctl.nix {};
  sudo = handleTest ./sudo.nix {};
  switchTest = handleTest ./switch-test.nix {};
  syncthing-init = handleTest ./syncthing-init.nix {};
  syncthing-relay = handleTest ./syncthing-relay.nix {};
  systemd = handleTest ./systemd.nix {};
  systemd-confinement = handleTest ./systemd-confinement.nix {};
  systemd-timesyncd = handleTest ./systemd-timesyncd.nix {};
  systemd-networkd-wireguard = handleTest ./systemd-networkd-wireguard.nix {};
  pdns-recursor = handleTest ./pdns-recursor.nix {};
  taskserver = handleTest ./taskserver.nix {};
  telegraf = handleTest ./telegraf.nix {};
  tiddlywiki = handleTest ./tiddlywiki.nix {};
  tinydns = handleTest ./tinydns.nix {};
  tor = handleTest ./tor.nix {};
  transmission = handleTest ./transmission.nix {};
  trezord = handleTest ./trezord.nix {};
  udisks2 = handleTest ./udisks2.nix {};
  upnp = handleTest ./upnp.nix {};
  uwsgi = handleTest ./uwsgi.nix {};
  vault = handleTest ./vault.nix {};
  virtualbox = handleTestOn ["x86_64-linux"] ./virtualbox.nix {};
  wireguard = handleTest ./wireguard {};
  wireguard-generated = handleTest ./wireguard/generated.nix {};
  wordpress = handleTest ./wordpress.nix {};
  xautolock = handleTest ./xautolock.nix {};
  xdg-desktop-portal = handleTest ./xdg-desktop-portal.nix {};
  xfce = handleTest ./xfce.nix {};
  xmonad = handleTest ./xmonad.nix {};
  xrdp = handleTest ./xrdp.nix {};
  xss-lock = handleTest ./xss-lock.nix {};
  yabar = handleTest ./yabar.nix {};
  zookeeper = handleTest ./zookeeper.nix {};
}
