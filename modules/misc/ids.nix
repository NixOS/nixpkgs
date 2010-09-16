# This module defines the global list of uids and gids.  We keep a
# central list to prevent id collissions.

{config, pkgs, ...}:

let

  options = {

    ids.uids = pkgs.lib.mkOption {
      description = ''
        The user IDs used in NixOS.
      '';
    };

    ids.gids = pkgs.lib.mkOption {
      description = ''
        The group IDs used in NixOS.
      '';
    };

  };

in
  
{
  require = options;

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
    portmap = 11;
    atd = 12;
    zabbix = 13;
    postfix = 14;
    dovecot = 15;
    tomcat = 16;
    gnunetd = 17;
    pulseaudio = 22; # must match `pulseaudio' GID
    gpsd = 23;
    polkituser = 28;
    uptimed = 29;
    ddclient = 30;
    davfs2 = 31;
    privoxy = 32;    
    osgi = 34;
    sabnzbd = 33;
    tor = 35;
    cups = 36;
    foldingAtHome = 37;
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
    portmap = 11;
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
    # When adding a gid, make sure it doesn't match an existing uid.

    users = 100;
    nixbld = 30000;
    nogroup = 65534;
  };

}
