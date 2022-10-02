# This module defines the global list of uids and gids.  We keep a
# central list to prevent id collisions.

# IMPORTANT!
# We only add static uids and gids for services where it is not feasible
# to change uids/gids on service start, for example a service with a lot of
# files. Please also check if the service is applicable for systemd's
# DynamicUser option and does not need a uid/gid allocation at all.
# Systemd can also change ownership of service directories using the
# RuntimeDirectory/StateDirectory options.

{ lib, ... }:

let
  inherit (lib) types;
in
{
  options = {

    ids.uids = lib.mkOption {
      internal = true;
      description = lib.mdDoc ''
        The user IDs used in NixOS.
      '';
      type = types.attrsOf types.int;
    };

    ids.gids = lib.mkOption {
      internal = true;
      description = lib.mdDoc ''
        The group IDs used in NixOS.
      '';
      type = types.attrsOf types.int;
    };

  };


  config = {

    ids.uids = {
      root = 0;
      #wheel = 1; # unused
      #kmem = 2; # unused
      #tty = 3; # unused
      messagebus = 4; # D-Bus
      haldaemon = 5;
      #disk = 6; # unused
      #vsftpd = 7; # dynamically allocated ass of 2021-09-14
      ftp = 8;
      # bitlbee = 9; # removed 2021-10-05 #139765
      #avahi = 10; # removed 2019-05-22
      nagios = 11;
      atd = 12;
      postfix = 13;
      #postdrop = 14; # unused
      dovecot = 15;
      tomcat = 16;
      #audio = 17; # unused
      #floppy = 18; # unused
      uucp = 19;
      #lp = 20; # unused
      #proc = 21; # unused
      pulseaudio = 22; # must match `pulseaudio' GID
      gpsd = 23;
      #cdrom = 24; # unused
      #tape = 25; # unused
      #video = 26; # unused
      #dialout = 27; # unused
      polkituser = 28;
      #utmp = 29; # unused
      # ddclient = 30; # converted to DynamicUser = true
      davfs2 = 31;
      disnix = 33;
      osgi = 34;
      tor = 35;
      cups = 36;
      foldingathome = 37;
      sabnzbd = 38;
      #kdm = 39; # dropped in 17.03
      #ghostone = 40; # dropped in 18.03
      git = 41;
      #fourstore = 42; # dropped in 20.03
      #fourstorehttp = 43; # dropped in 20.03
      #virtuoso = 44;  dropped module
      #rtkit = 45; # dynamically allocated 2021-09-03
      dovecot2 = 46;
      dovenull2 = 47;
      prayer = 49;
      mpd = 50;
      clamav = 51;
      #fprot = 52; # unused
      # bind = 53; #dynamically allocated as of 2021-09-03
      wwwrun = 54;
      #adm = 55; # unused
      spamd = 56;
      #networkmanager = 57; # unused
      nslcd = 58;
      scanner = 59;
      nginx = 60;
      chrony = 61;
      #systemd-journal = 62; # unused
      smtpd = 63;
      smtpq = 64;
      supybot = 65;
      iodined = 66;
      #libvirtd = 67; # unused
      graphite = 68;
      #statsd = 69; # removed 2018-11-14
      transmission = 70;
      postgres = 71;
      #vboxusers = 72; # unused
      #vboxsf = 73; # unused
      smbguest = 74;  # unused
      varnish = 75;
      datadog = 76;
      lighttpd = 77;
      lightdm = 78;
      freenet = 79;
      ircd = 80;
      bacula = 81;
      #almir = 82; # removed 2018-03-25, the almir package was removed in 30291227f2411abaca097773eedb49b8f259e297 during 2017-08
      deluge = 83;
      mysql = 84;
      rabbitmq = 85;
      activemq = 86;
      gnunet = 87;
      oidentd = 88;
      quassel = 89;
      amule = 90;
      minidlna = 91;
      elasticsearch = 92;
      tcpcryptd = 93; # tcpcryptd uses a hard-coded uid. We patch it in Nixpkgs to match this choice.
      firebird = 95;
      #keys = 96; # unused
      #haproxy = 97; # dynamically allocated as of 2020-03-11
      #mongodb = 98; #dynamically allocated as of 2021-09-03
      #openldap = 99; # dynamically allocated as of PR#94610
      #users = 100; # unused
      # cgminer = 101; #dynamically allocated as of 2021-09-17
      munin = 102;
      #logcheck = 103; #dynamically allocated as of 2021-09-17
      #nix-ssh = 104; #dynamically allocated as of 2021-09-03
      dictd = 105;
      couchdb = 106;
      #searx = 107; # dynamically allocated as of 2020-10-27
      #kippo = 108; # removed 2021-10-07, the kippo package was removed in 1b213f321cdbfcf868b96fd9959c24207ce1b66a during 2021-04
      jenkins = 109;
      systemd-journal-gateway = 110;
      #notbit = 111; # unused
      aerospike = 111;
      #ngircd = 112; #dynamically allocated as of 2021-09-03
      #btsync = 113; # unused
      #minecraft = 114; #dynamically allocated as of 2021-09-03
      vault = 115;
      # rippled = 116; #dynamically allocated as of 2021-09-18
      murmur = 117;
      foundationdb = 118;
      newrelic = 119;
      starbound = 120;
      hydra = 122;
      spiped = 123;
      teamspeak = 124;
      influxdb = 125;
      nsd = 126;
      gitolite = 127;
      znc = 128;
      polipo = 129;
      mopidy = 130;
      #docker = 131; # unused
      gdm = 132;
      #dhcpd = 133; # dynamically allocated as of 2021-09-03
      siproxd = 134;
      mlmmj = 135;
      #neo4j = 136;# dynamically allocated as of 2021-09-03
      riemann = 137;
      riemanndash = 138;
      #radvd = 139;# dynamically allocated as of 2021-09-03
      #zookeeper = 140;# dynamically allocated as of 2021-09-03
      #dnsmasq = 141;# dynamically allocated as of 2021-09-03
      #uhub = 142; # unused
      yandexdisk = 143;
      mxisd = 144; # was once collectd
      #consul = 145;# dynamically allocated as of 2021-09-03
      #mailpile = 146; # removed 2022-01-12
      redmine = 147;
      #seeks = 148; # removed 2020-06-21
      prosody = 149;
      i2pd = 150;
      systemd-coredump = 151;
      systemd-network = 152;
      systemd-resolve = 153;
      systemd-timesync = 154;
      liquidsoap = 155;
      #etcd = 156;# dynamically allocated as of 2021-09-03
      hbase = 158;
      opentsdb = 159;
      scollector = 160;
      bosun = 161;
      kubernetes = 162;
      peerflix = 163;
      #chronos = 164; # removed 2020-08-15
      gitlab = 165;
      # tox-bootstrapd = 166; removed 2021-09-15
      cadvisor = 167;
      nylon = 168;
      #apache-kafka = 169;# dynamically allocated as of 2021-09-03
      #panamax = 170; # unused
      exim = 172;
      #fleet = 173; # unused
      #input = 174; # unused
      sddm = 175;
      #tss = 176; # dynamically allocated as of 2021-09-17
      #memcached = 177; removed 2018-01-03
      #ntp = 179; # dynamically allocated as of 2021-09-17
      zabbix = 180;
      #redis = 181; removed 2018-01-03
      #unifi = 183; dynamically allocated as of 2021-09-17
      uptimed = 184;
      #zope2 = 185; # dynamically allocated as of 2021-09-18
      #ripple-data-api = 186; dynamically allocated as of 2021-09-17
      mediatomb = 187;
      #rdnssd = 188; #dynamically allocated as of 2021-09-18
      ihaskell = 189;
      i2p = 190;
      lambdabot = 191;
      asterisk = 192;
      plex = 193;
      plexpy = 195;
      grafana = 196;
      skydns = 197;
      # ripple-rest = 198; # unused, removed 2017-08-12
      # nix-serve = 199; # unused, removed 2020-12-12
      #tvheadend = 200; # dynamically allocated as of 2021-09-18
      uwsgi = 201;
      gitit = 202;
      riemanntools = 203;
      subsonic = 204;
      # riak = 205; # unused, remove 2022-07-22
      #shout = 206; # dynamically allocated as of 2021-09-18
      gateone = 207;
      namecoin = 208;
      #lxd = 210; # unused
      #kibana = 211;# dynamically allocated as of 2021-09-03
      xtreemfs = 212;
      calibre-server = 213;
      #heapster = 214; #dynamically allocated as of 2021-09-17
      bepasty = 215;
      # pumpio = 216; # unused, removed 2018-02-24
      nm-openvpn = 217;
      # mathics = 218; # unused, removed 2020-08-15
      ejabberd = 219;
      postsrsd = 220;
      opendkim = 221;
      dspam = 222;
      # gale = 223; removed 2021-06-10
      matrix-synapse = 224;
      rspamd = 225;
      # rmilter = 226; # unused, removed 2019-08-22
      cfdyndns = 227;
      # gammu-smsd = 228; #dynamically allocated as of 2021-09-17
      pdnsd = 229;
      octoprint = 230;
      avahi-autoipd = 231;
      # nntp-proxy = 232; #dynamically allocated as of 2021-09-17
      mjpg-streamer = 233;
      #radicale = 234;# dynamically allocated as of 2021-09-03
      hydra-queue-runner = 235;
      hydra-www = 236;
      syncthing = 237;
      caddy = 239;
      taskd = 240;
      # factorio = 241; # DynamicUser = true
      # emby = 242; # unusued, removed 2019-05-01
      #graylog = 243;# dynamically allocated as of 2021-09-03
      sniproxy = 244;
      nzbget = 245;
      mosquitto = 246;
      #toxvpn = 247; # dynamically allocated as of 2021-09-18
      # squeezelite = 248; # DynamicUser = true
      turnserver = 249;
      #smokeping = 250;# dynamically allocated as of 2021-09-03
      gocd-agent = 251;
      gocd-server = 252;
      terraria = 253;
      mattermost = 254;
      prometheus = 255;
      telegraf = 256;
      gitlab-runner = 257;
      postgrey = 258;
      hound = 259;
      leaps = 260;
      ipfs  = 261;
      # stanchion = 262; # unused, removed 2020-10-14
      # riak-cs = 263; # unused, removed 2020-10-14
      infinoted = 264;
      sickbeard = 265;
      headphones = 266;
      # couchpotato = 267; # unused, removed 2022-01-01
      gogs = 268;
      #pdns-recursor = 269; # dynamically allocated as of 2020-20-18
      #kresd = 270; # switched to "knot-resolver" with dynamic ID
      rpc = 271;
      #geoip = 272; # new module uses DynamicUser
      fcron = 273;
      sonarr = 274;
      radarr = 275;
      jackett = 276;
      aria2 = 277;
      clickhouse = 278;
      rslsync = 279;
      minio = 280;
      kanboard = 281;
      # pykms = 282; # DynamicUser = true
      kodi = 283;
      restya-board = 284;
      mighttpd2 = 285;
      hass = 286;
      #monero = 287; # dynamically allocated as of 2021-05-08
      ceph = 288;
      duplicati = 289;
      monetdb = 290;
      restic = 291;
      openvpn = 292;
      # meguca = 293; # removed 2020-08-21
      yarn = 294;
      hdfs = 295;
      mapred = 296;
      hadoop = 297;
      hydron = 298;
      cfssl = 299;
      cassandra = 300;
      qemu-libvirtd = 301;
      # kvm = 302; # unused
      # render = 303; # unused
      # zeronet = 304; # removed 2019-01-03
      lirc = 305;
      lidarr = 306;
      slurm = 307;
      kapacitor = 308;
      solr = 309;
      alerta = 310;
      minetest = 311;
      rss2email = 312;
      cockroachdb = 313;
      zoneminder = 314;
      paperless = 315;
      #mailman = 316;  # removed 2019-08-30
      zigbee2mqtt = 317;
      # shadow = 318; # unused
      hqplayer = 319;
      moonraker = 320;
      distcc = 321;
      webdav = 322;
      pipewire = 323;
      rstudio-server = 324;
      localtimed = 325;

      # When adding a uid, make sure it doesn't match an existing gid. And don't use uids above 399!

      nixbld = 30000; # start of range of uids
      nobody = 65534;
    };

    ids.gids = {
      root = 0;
      wheel = 1;
      kmem = 2;
      tty = 3;
      messagebus = 4; # D-Bus
      haldaemon = 5;
      disk = 6;
      #vsftpd = 7; # dynamically allocated as of 2021-09-14
      ftp = 8;
      # bitlbee = 9; # removed 2021-10-05 #139765
      #avahi = 10; # removed 2019-05-22
      #nagios = 11; # unused
      atd = 12;
      postfix = 13;
      postdrop = 14;
      dovecot = 15;
      tomcat = 16;
      audio = 17;
      floppy = 18;
      uucp = 19;
      lp = 20;
      proc = 21;
      pulseaudio = 22; # must match `pulseaudio' UID
      gpsd = 23;
      cdrom = 24;
      tape = 25;
      video = 26;
      dialout = 27;
      #polkituser = 28; # currently unused, polkitd doesn't need a group
      utmp = 29;
      # ddclient = 30; # converted to DynamicUser = true
      davfs2 = 31;
      disnix = 33;
      osgi = 34;
      tor = 35;
      #cups = 36; # unused
      #foldingathome = 37; # unused
      #sabnzd = 38; # unused
      #kdm = 39; # unused, even before 17.03
      #ghostone = 40; # dropped in 18.03
      git = 41;
      fourstore = 42;
      fourstorehttp = 43;
      virtuoso = 44;
      #rtkit = 45; # unused
      dovecot2 = 46;
      dovenull2 = 47;
      prayer = 49;
      mpd = 50;
      clamav = 51;
      #fprot = 52; # unused
      #bind = 53; # unused
      wwwrun = 54;
      adm = 55;
      spamd = 56;
      networkmanager = 57;
      nslcd = 58;
      scanner = 59;
      nginx = 60;
      chrony = 61;
      systemd-journal = 62;
      smtpd = 63;
      smtpq = 64;
      supybot = 65;
      iodined = 66;
      libvirtd = 67;
      graphite = 68;
      #statsd = 69; # removed 2018-11-14
      transmission = 70;
      postgres = 71;
      vboxusers = 72;
      vboxsf = 73;
      smbguest = 74;  # unused
      varnish = 75;
      datadog = 76;
      lighttpd = 77;
      lightdm = 78;
      freenet = 79;
      ircd = 80;
      bacula = 81;
      #almir = 82; # removed 2018-03-25, the almir package was removed in 30291227f2411abaca097773eedb49b8f259e297 during 2017-08
      deluge = 83;
      mysql = 84;
      rabbitmq = 85;
      activemq = 86;
      gnunet = 87;
      oidentd = 88;
      quassel = 89;
      amule = 90;
      minidlna = 91;
      elasticsearch = 92;
      #tcpcryptd = 93; # unused
      firebird = 95;
      keys = 96;
      #haproxy = 97; # dynamically allocated as of 2020-03-11
      #mongodb = 98; # unused
      #openldap = 99; # dynamically allocated as of PR#94610
      munin = 102;
      #logcheck = 103; # unused
      #nix-ssh = 104; # unused
      dictd = 105;
      couchdb = 106;
      #searx = 107; # dynamically allocated as of 2020-10-27
      #kippo = 108; # removed 2021-10-07, the kippo package was removed in 1b213f321cdbfcf868b96fd9959c24207ce1b66a during 2021-04
      jenkins = 109;
      systemd-journal-gateway = 110;
      #notbit = 111; # unused
      aerospike = 111;
      #ngircd = 112; # unused
      #btsync = 113; # unused
      #minecraft = 114; # unused
      vault = 115;
      #ripped = 116; # unused
      murmur = 117;
      foundationdb = 118;
      newrelic = 119;
      starbound = 120;
      hydra = 122;
      spiped = 123;
      teamspeak = 124;
      influxdb = 125;
      nsd = 126;
      gitolite = 127;
      znc = 128;
      polipo = 129;
      mopidy = 130;
      docker = 131;
      gdm = 132;
      #dhcpcd = 133; # unused
      siproxd = 134;
      mlmmj = 135;
      #neo4j = 136; # unused
      riemann = 137;
      riemanndash = 138;
      #radvd = 139; # unused
      #zookeeper = 140; # unused
      #dnsmasq = 141; # unused
      uhub = 142;
      #yandexdisk = 143; # unused
      mxisd = 144; # was once collectd
      #consul = 145; # unused
      #mailpile = 146; # removed 2022-01-12
      redmine = 147;
      #seeks = 148; # removed 2020-06-21
      prosody = 149;
      i2pd = 150;
      systemd-network = 152;
      systemd-resolve = 153;
      systemd-timesync = 154;
      liquidsoap = 155;
      #etcd = 156; # unused
      hbase = 158;
      opentsdb = 159;
      scollector = 160;
      bosun = 161;
      kubernetes = 162;
      #peerflix = 163; # unused
      #chronos = 164; # unused
      gitlab = 165;
      nylon = 168;
      #panamax = 170; # unused
      exim = 172;
      #fleet = 173; # unused
      input = 174;
      sddm = 175;
      #tss = 176; #dynamically allocateda as of 2021-09-20
      #memcached = 177; # unused, removed 2018-01-03
      #ntp = 179; # unused
      zabbix = 180;
      #redis = 181; # unused, removed 2018-01-03
      #unifi = 183; # unused
      #uptimed = 184; # unused
      #zope2 = 185; # unused
      #ripple-data-api = 186; #unused
      mediatomb = 187;
      #rdnssd = 188; # unused
      ihaskell = 189;
      i2p = 190;
      lambdabot = 191;
      asterisk = 192;
      plex = 193;
      sabnzbd = 194;
      #grafana = 196; #unused
      #skydns = 197; #unused
      # ripple-rest = 198; # unused, removed 2017-08-12
      #nix-serve = 199; #unused
      #tvheadend = 200; #unused
      uwsgi = 201;
      gitit = 202;
      riemanntools = 203;
      subsonic = 204;
      # riak = 205;#unused, removed 2022-06-22
      #shout = 206; #unused
      gateone = 207;
      namecoin = 208;
      #lxd = 210; # unused
      #kibana = 211;
      xtreemfs = 212;
      calibre-server = 213;
      bepasty = 215;
      # pumpio = 216; # unused, removed 2018-02-24
      nm-openvpn = 217;
      mathics = 218;
      ejabberd = 219;
      postsrsd = 220;
      opendkim = 221;
      dspam = 222;
      # gale = 223; removed 2021-06-10
      matrix-synapse = 224;
      rspamd = 225;
      # rmilter = 226; # unused, removed 2019-08-22
      cfdyndns = 227;
      pdnsd = 229;
      octoprint = 230;
      #radicale = 234;# dynamically allocated as of 2021-09-03
      syncthing = 237;
      caddy = 239;
      taskd = 240;
      # factorio = 241; # unused
      # emby = 242; # unused, removed 2019-05-01
      sniproxy = 244;
      nzbget = 245;
      mosquitto = 246;
      #toxvpn = 247; # unused
      #squeezelite = 248; #unused
      turnserver = 249;
      #smokeping = 250;# dynamically allocated as of 2021-09-03
      gocd-agent = 251;
      gocd-server = 252;
      terraria = 253;
      mattermost = 254;
      prometheus = 255;
      #telegraf = 256; # unused
      gitlab-runner = 257;
      postgrey = 258;
      hound = 259;
      leaps = 260;
      ipfs = 261;
      # stanchion = 262; # unused, removed 2020-10-14
      # riak-cs = 263; # unused, removed 2020-10-14
      infinoted = 264;
      sickbeard = 265;
      headphones = 266;
      # couchpotato = 267; # unused, removed 2022-01-01
      gogs = 268;
      #kresd = 270; # switched to "knot-resolver" with dynamic ID
      #rpc = 271; # unused
      #geoip = 272; # unused
      fcron = 273;
      sonarr = 274;
      radarr = 275;
      jackett = 276;
      aria2 = 277;
      clickhouse = 278;
      rslsync = 279;
      minio = 280;
      kanboard = 281;
      # pykms = 282; # DynamicUser = true
      kodi = 283;
      restya-board = 284;
      mighttpd2 = 285;
      hass = 286;
      # monero = 287; # dynamically allocated as of 2021-05-08
      ceph = 288;
      duplicati = 289;
      monetdb = 290;
      restic = 291;
      openvpn = 292;
      # meguca = 293; # removed 2020-08-21
      yarn = 294;
      hdfs = 295;
      mapred = 296;
      hadoop = 297;
      hydron = 298;
      cfssl = 299;
      cassandra = 300;
      qemu-libvirtd = 301;
      kvm = 302; # default udev rules from systemd requires these
      render = 303; # default udev rules from systemd requires these
      sgx = 304; # default udev rules from systemd requires these
      lirc = 305;
      lidarr = 306;
      slurm = 307;
      kapacitor = 308;
      solr = 309;
      alerta = 310;
      minetest = 311;
      rss2email = 312;
      cockroachdb = 313;
      zoneminder = 314;
      paperless = 315;
      #mailman = 316;  # removed 2019-08-30
      zigbee2mqtt = 317;
      shadow = 318;
      hqplayer = 319;
      moonraker = 320;
      distcc = 321;
      webdav = 322;
      pipewire = 323;
      rstudio-server = 324;
      localtimed = 325;

      # When adding a gid, make sure it doesn't match an existing
      # uid. Users and groups with the same name should have equal
      # uids and gids. Also, don't use gids above 399!

      # For exceptional cases where you really need a gid above 399, leave a
      # comment stating why.
      #
      # Also, avoid the following GID ranges:
      #
      #  1000 - 29999: user accounts (see ../config/update-users-groups.pl)
      # 30000 - 31000: nixbld users (the upper limit is arbitrarily chosen)
      # 61184 - 65519: systemd DynamicUser (see systemd.exec(5))
      #         65535: the error return sentinel value when uid_t was 16 bits
      #
      # 100000 - 6653600: subgid allocated for user namespaces
      #                   (see ../config/update-users-groups.pl)
      #       4294967294: unauthenticated user in some NFS implementations
      #       4294967295: error return sentinel value
      #
      # References:
      # https://www.debian.org/doc/debian-policy/ch-opersys.html#uid-and-gid-classes

      onepassword = 31001; # 1Password requires that its GID be larger than 1000
      onepassword-cli = 31002; # 1Password requires that its GID be larger than 1000

      users = 100;
      nixbld = 30000;
      nogroup = 65534;
    };

  };

}
