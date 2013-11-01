# This module defines the global list of uids and gids.  We keep a
# central list to prevent id collisions.

{ config, pkgs, ... }:

{
  options = {

    ids.uids = pkgs.lib.mkOption {
      internal = true;
      description = ''
        The user IDs used in NixOS.
      '';
    };

    ids.gids = pkgs.lib.mkOption {
      internal = true;
      description = ''
        The group IDs used in NixOS.
      '';
    };

  };


  config = {

    ids.uids = {
      root = 0;
      nscd = 1;
      sshd = 2;
      ntp = 3;
      messagebus = 4; # D-Bus
      haldaemon = 5;
      nagios = 6;
      vsftpd = 7;
      ftp = 8;
      bitlbee = 9;
      avahi = 10;
      atd = 12;
      zabbix = 13;
      postfix = 14;
      dovecot = 15;
      tomcat = 16;
      pulseaudio = 22; # must match `pulseaudio' GID
      gpsd = 23;
      polkituser = 28;
      uptimed = 29;
      ddclient = 30;
      davfs2 = 31;
      privoxy = 32;
      osgi = 34;
      tor = 35;
      cups = 36;
      foldingAtHome = 37;
      sabnzbd = 38;
      kdm = 39;
      ghostOne = 40;
      git = 41;
      fourStore = 42;
      fourStoreEndpoint = 43;
      virtuoso = 44;
      rtkit = 45;
      dovecot2 = 46;
      dovenull2 = 47;
      unbound = 48;
      prayer = 49;
      mpd = 50;
      clamav = 51;
      fprot = 52;
      bind = 53;
      wwwrun = 54;
      spamd = 56;
      nslcd = 58;
      nginx = 60;
      chrony = 61;
      smtpd = 63;
      smtpq = 64;
      supybot = 65;
      iodined = 66;
      graphite = 68;
      statsd = 69;
      transmission = 70;
      postgres = 71;
      smbguest = 74;
      varnish = 75;
      dd-agent = 76;
      lighttpd = 77;
      lightdm = 78;
      freenet = 79;
      ircd = 80;
      bacula = 81;
      almir = 82;
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
      zope2 = 94;
      firebird = 95;
      redis = 96;
      haproxy = 97;

      # When adding a uid, make sure it doesn't match an existing gid.

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
      vsftpd = 7;
      ftp = 8;
      bitlbee = 9;
      avahi = 10;
      atd = 12;
      postfix = 13;
      postdrop = 14;
      dovecot = 15;
      audio = 17;
      floppy = 18;
      uucp = 19;
      lp = 20;
      tomcat = 21;
      pulseaudio = 22; # must match `pulseaudio' UID
      gpsd = 23;
      cdrom = 24;
      tape = 25;
      video = 26;
      dialout = 27;
      polkituser = 28;
      utmp = 29;
      davfs2 = 31;
      privoxy = 32;
      disnix = 33;
      osgi = 34;
      ghostOne = 40;
      git = 41;
      fourStore = 42;
      fourStoreEndpoint = 43;
      virtuoso = 44;
      dovecot2 = 46;
      prayer = 49;
      mpd = 50;
      clamav = 51;
      fprot = 52;
      wwwrun = 54;
      adm = 55;
      spamd = 56;
      networkmanager = 57;
      nslcd = 58;
      scanner = 59;
      nginx = 60;
      systemd-journal = 62;
      smtpd = 63;
      smtpq = 64;
      supybot = 65;
      iodined = 66;
      libvirtd = 67;
      graphite = 68;
      transmission = 70;
      postgres = 71;
      vboxusers = 72;
      vboxsf = 73;
      smbguest = 74;
      varnish = 75;
      dd-agent = 76;
      lighttpd = 77;
      lightdm = 78;
      freenet = 79;
      ircd = 80;
      bacula = 81;
      almir = 82;
      deluge = 83;
      mysql = 84;
      rabbitmq = 85;
      activemq = 86;
      gnunet = 87;
      oidentd = 88;
      quassel = 89;
      amule = 90;
      minidlna = 91;
      haproxy = 92;

      # When adding a gid, make sure it doesn't match an existing uid.

      users = 100;
      nixbld = 30000;
      nogroup = 65534;
    };

  };

}
