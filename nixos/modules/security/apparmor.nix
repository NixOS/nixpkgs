{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types concatMapStrings;
  cfg = config.security.apparmor;
in

{
   options = {
     security.apparmor = {
       enable = mkOption {
         type = types.bool;
         default = false;
         description = "Enable the AppArmor Mandatory Access Control system.";
       };
       extraParserConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Append configuration lines to /etc/apparmor/parser.conf";
       };
       extraLogConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Append configuration lines to /etc/apparmor/logprof.conf";
       };
       profiles = mkOption {
         type = types.listOf types.path;
         default = [];
         description = "List of files containing AppArmor profiles.";
       };
       packages = mkOption {
         type = types.listOf types.package;
         default = [];
         description = "List of packages to be added to apparmor's include path";
       };
     };
   };

   config = mkIf cfg.enable {
     environment.systemPackages = [ pkgs.apparmor-utils ];

     # Needed globals and abstractions that can be included in profiles
     environment.etc."/apparmor.d/abstractions".source = pkgs.apparmor-profiles + "/etc/apparmor.d/abstractions";
     environment.etc."/apparmor.d/tunables".source = pkgs.apparmor-profiles + "/etc/apparmor.d/tunables";

     environment.etc."apparmor/parser.conf".text = ''
      Optimize=compress-fast
      ${cfg.extraParserConfig}
    '';

     # Pretty much everything in here, is there to
     # prevent apparmor utilities from crashing.
     environment.etc."apparmor/logprof.conf".text =
      builtins.replaceStrings
      [
        "/usr"
      ]
      [
        "/nix/store/*"
      ]
     ''
      [settings]
      profiledir = /etc/apparmor.d
      inactive_profiledir = /usr/share/apparmor/extra-profiles 
      parser = ${pkgs.apparmor-parser}/bin/apparmor_parser
      logfiles = /var/log/messages 

      ldd = ${pkgs.glibc.bin}/bin/ldd
      logger = ${pkgs.logger}/bin/logger
      default_owner_prompt = 1
      custom_includes = 

      [qualifiers]

      [globs]
      # /foo/bar/lib/libbaz.so -> /foo/bar/lib/lib*
      /lib/lib[^\/]+so[^\/]*$           = /lib/lib*so*

      # strip kernel version numbers from kernel module accesses
      ^/lib/modules/[^\/]+\/            = /lib/modules/*/

      # strip pid numbers from /proc accesses
      ^/proc/\d+/                       = /proc/*/

      # if it looks like a home directory, glob out the username
      ^/home/[^\/]+                     = /home/*

      # if they use any perl modules, grant access to all
      ^/usr/lib/perl5/.+$               = /usr/lib/perl5/**
      ^/usr/lib/[^\/]+/perl5?/.+$       = /usr/lib/@{multiarch}/perl{,5}/**

      # locale foo
      ^/usr/lib/locale/.+$              = /usr/lib/locale/**
      ^/usr/share/locale/.+$            = /usr/share/locale/**

      # timezone fun
      ^/usr/share/zoneinfo/.+$          = /usr/share/zoneinfo/**

      # /foobar/fonts/baz -> /foobar/fonts/**
      /fonts/.+$                        = /fonts/**

      # turn /foo/bar/baz.8907234 into /foo/bar/baz.*
      # BUGBUG - this one looked weird because it would suggest a glob for
      # BUGBUG - libfoo.so.5.6.0 that looks like libfoo.so.5.6.*
      # \.\d+$                            = .*

      # some various /etc/security poo -- dunno about these ones...
      ^/etc/security/_[^\/]+$           = /etc/security/*
      ^/lib/security/pam_filter/[^\/]+$ = /lib/security/pam_filter/*
      ^/lib/security/pam_[^\/]+\.so$    = /lib/security/pam_*.so

      ^/etc/pam.d/[^\/]+$               = /etc/pam.d/*
      ^/etc/profile.d/[^\/]+\.sh$       = /etc/profile.d/*.sh

      [required_hats]

      [defaulthat]

      [repository]
        distro         = ubuntu-intrepid
        url            = http://apparmor.test.opensuse.org/backend/api
        preferred_user = ubuntu

      ${cfg.extraLogConfig}
     '';

     environment.etc."/apparmor/severity.db".text =
      builtins.replaceStrings
      [
        "/usr"
      ]
      [
        "/nix/store/*"
      ]
      ''

      # ------------------------------------------------------------------
      #
      #    Copyright (C) 2002-2005 Novell/SUSE
      #    Copyright (C) 2014 Canonical Ltd.
      #
      #    This program is free software; you can redistribute it and/or
      #    modify it under the terms of version 2 of the GNU General Public
      #    License published by the Free Software Foundation.
      #
      # ------------------------------------------------------------------

      # Allow this process to 0wn the machine:
             CAP_SYS_ADMIN 10
             CAP_SYS_CHROOT 10
             CAP_SYS_MODULE 10
             CAP_SYS_PTRACE 10
             CAP_SYS_RAWIO 10
             CAP_MAC_ADMIN 10
             CAP_MAC_OVERRIDE 10
      # Allow other processes to 0wn the machine:
             CAP_SETPCAP 9
             CAP_SETFCAP 9
             CAP_CHOWN 9
             CAP_FSETID 9
             CAP_MKNOD 9
             CAP_LINUX_IMMUTABLE 9
             CAP_DAC_OVERRIDE 9
             CAP_SETGID 9
             CAP_SETUID 9
             CAP_FOWNER 9
      # Denial of service, bypass audit controls, information leak
             CAP_SYS_TIME 8
             CAP_NET_ADMIN 8
             CAP_SYS_RESOURCE 8
             CAP_KILL 8
             CAP_IPC_OWNER 8
             CAP_SYS_PACCT 8
             CAP_SYS_BOOT 8
             CAP_NET_BIND_SERVICE 8
             CAP_NET_RAW 8
             CAP_SYS_NICE 8
             CAP_LEASE 8
             CAP_IPC_LOCK 8
             CAP_SYS_TTY_CONFIG 8
             CAP_AUDIT_CONTROL 8
             CAP_AUDIT_WRITE 8
             CAP_SYSLOG 8
             CAP_WAKE_ALARM 8
             CAP_BLOCK_SUSPEND 8
             CAP_DAC_READ_SEARCH 7
             CAP_AUDIT_READ 7
      # unused
             CAP_NET_BROADCAST 0

      # filename	r w x
      # 'hard drives' are generally 4 10 0
      /**/lost+found/**	5 5 0
      /boot/**	7 10 0
      /etc/passwd*	4 8 0
      /etc/group*	4 8 0
      /etc/shadow*	7 9 0
      /etc/shadow*	7 9 0
      /home/*/.ssh/**	7 9 0
      /home/*/.gnupg/**	5 7 0
      /home/**	4 6 0
      /srv/**         4 6 0
      /proc/**	6 9 0
      /proc/sys/kernel/hotplug	2 10 0
      /proc/sys/kernel/modprobe	2 10 0
      /proc/kallsyms	7 0 0
      /sys/**		4 8 0
      /sys/power/state	2 8 0
      /sys/firmware/**	2 10 0
      /dev/pts/*	8 9 0
      /dev/ptmx	8 9 0
      /dev/pty*	8 9 0
      /dev/null	0 0 0
      /dev/adbmouse	3 8 0
      /dev/ataraid	9 10 0
      /dev/zero	0 0 0
      /dev/agpgart*	8 10 0
      /dev/aio	3 3 0
      /dev/cbd/*	5 5 0
      /dev/cciss/*	4 10 0
      /dev/capi*	4 6 0
      /dev/cfs0	4 10 0
      /dev/compaq/*   4 10 0
      /dev/cdouble*   4 8 0
      /dev/cpu**	5 5 0
      /dev/cpu**microcode	1 10 0
      /dev/double*	4 8 0
      /dev/hd*	4 10 0
      /dev/sd*	4 10 0
      /dev/ida/*	4 10 0
      /dev/input/*	4 8 0
      /dev/mapper/control	4 10 0
      /dev/*mem	8 10 0
      /dev/loop*	4 10 0
      /dev/lp*	0 4 0
      /dev/md*	4 10 0
      /dev/msr	4 10 0
      /dev/nb*	4 10 0
      /dev/ram*	8 10 0
      /dev/rd/*	4 10 0
      /dev/*random	3 1 0
      /dev/sbpcd*	4 0 0
      /dev/rtc	6 0 0
      /dev/sd*	4 10 0
      /dev/sc*	4 10 0
      /dev/sg*	4 10 0
      /dev/st*	4 10 0
      /dev/snd/*	3 8 0
      /dev/usb/mouse*	4 6 0
      /dev/usb/hid*	4 6 0
      /dev/usb/tty*	4 6 0
      /dev/tty*	8 9 0
      /dev/stderr	0 0 0
      /dev/stdin	0 0 0
      /dev/stdout	0 0 0
      /dev/ubd*	4 10 0
      /dev/usbmouse*	4 6 0
      /dev/userdma	8 10 0
      /dev/vcs*	8 9 0
      /dev/xta*	4 10 0
      /dev/zero	0 0 0
      /dev/inittcl	8 10 0
      /dev/log	5 7 0
      /etc/fstab	3 8 0
      /etc/mtab	3 5 0
      /etc/SuSEconfig/*	1 8 0
      /etc/X11/*	2 7 0
      /etc/X11/xinit/*	2 8 0
      /etc/SuSE-release	1 5 0
      /etc/issue*	1 3 0
      /etc/motd	1 3 0
      /etc/aliases.d/*	1 7 0
      /etc/cron*	1 9 0
      /etc/cups/*	2 7 0
      /etc/default/*	3 8 0
      /etc/init.d/*	1 10 0
      /etc/permissions.d/*	1 8 0
      /etc/ppp/*	2 6 0
      /etc/ppp/*secrets	8 6 0
      /etc/profile.d/*	1 8 0
      /etc/skel/*	0 7 0
      /etc/sysconfig/*	4 10 0
      /etc/xinetd.d/*	1 9 0
      /etc/termcap/*	1 4 0
      /etc/ld.so.*	1 9 0
      /etc/pam.d/*	3 9 0
      /etc/udev/*	3 9 0
      /etc/insserv.conf	3 6 0
      /etc/security/*	1 9 0
      /etc/securetty	0 7 0
      /etc/sudoers	4 9 0
      /etc/hotplug/*	2 10 0
      /etc/xinitd.conf	1 9 0
      /etc/gpm/*	2 10 0
      /etc/ssl/**	2 7 0
      /etc/shadow*	5 9 0
      /etc/bash.bashrc	1 9 0
      /etc/csh.cshrc		1 9 0
      /etc/csh.login		1 9 0
      /etc/inittab	1 10 0
      /etc/profile*		1 9 0
      /etc/shells	1 5 0
      /etc/alternatives	1 6 0
      /etc/sysctl.conf	3 7 0
      /etc/dev.d/*	1 8 0
      /etc/manpath.config	1 6 0
      /etc/permissions*	1 8 0
      /etc/evms.conf	3 8 0
      /etc/exports	3 8 0
      /etc/samba/*	5 8 0
      /etc/ssh/*	3 8 0
      /etc/ssh/ssh_host_*key 8 8 0
      /etc/krb5.conf	4 8 0
      /etc/ntp.conf	3 8 0
      /etc/auto.*	3 8 0
      /etc/postfix/*	3 7 0
      /etc/postfix/*passwd*	6 7 0
      /etc/postfix/*cert*	6 7 0
      /etc/foomatic/*	3 5 0
      /etc/printcap	3 5 0
      /etc/youservers	4 9 0
      /etc/grub.conf	7 10 0
      /etc/modules.conf	4 10 0
      /etc/resolv.conf	2 7 0
      /etc/apache2/**	3 7 0
      /etc/apache2/**ssl**	7 7 0
      /etc/subdomain.d/**	6 10 0
      /etc/apparmor.d/**	6 10 0
      /etc/apparmor/**	6 10 0
      /var/log/**		3 8 0
      /var/adm/SuSEconfig/**	3 8 0
      /var/adm/**		3 7 0
      /var/lib/rpm/**		4 8 0
      /var/run/nscd/*		3 3 0
      /var/run/.nscd_socket	3 3 0
      /usr/share/doc/**	1 1 0
      /usr/share/man/**	3 5 0
      /usr/X11/man/**		3 5 0
      /usr/share/info/**	2 4 0
      /usr/share/java/**	2 5 0
      /usr/share/locale/**	2 4 0
      /usr/share/sgml/**	2 4 0
      /usr/share/YaST2/**	3 9 0
      /usr/share/ghostscript/**	3 5 0
      /usr/share/terminfo/**	1 8 0
      /usr/share/latex2html/**	2 4 0
      /usr/share/cups/**	5 6 0
      /usr/share/susehelp/**	2 6 0
      /usr/share/susehelp/cgi-bin/**	3 7 7
      /usr/share/zoneinfo/**	2 7 0
      /usr/share/zsh/**	3 6 0
      /usr/share/vim/**	3 8 0
      /usr/share/groff/**	3 7 0
      /usr/share/vnc/**	3 8 0
      /usr/share/wallpapers/**	2 4 0
      /usr/X11**		3 8 5
      /usr/X11*/bin/XFree86	3 8 8
      /usr/X11*/bin/Xorg	3 8 8
      /usr/X11*/bin/sux	3 8 8
      /usr/X11*/bin/xconsole	3 7 7
      /usr/X11*/bin/xhost	3 7 7
      /usr/X11*/bin/xauth	3 7 7
      /usr/X11*/bin/ethereal	3 6 8
      /usr/lib/ooo-**		3 6 5
      /usr/lib/lsb/**		2 8 8
      /usr/lib/pt_chwon	2 8 5
      /usr/lib/tcl**		2 5 3
      /usr/lib/lib*so*	3 8 4
      /usr/lib/iptables/*	2 8 2
      /usr/lib/perl5/**	4 10 6
      /usr/lib/*/perl/**	4 10 6
      /usr/lib/*/perl5/**	4 10 6
      /usr/lib/gconv/*	4 7 4
      /usr/lib/locale/**	4 8 0
      /usr/lib/jvm/**		5 7 5
      /usr/lib/sasl*/**	5 8 4
      /usr/lib/jvm-exports/**	5 7 5
      /usr/lib/jvm-private/**	5 7 5
      /usr/lib/python*/**	5 7 5
      /usr/lib/libkrb5*	4 8 4
      /usr/lib/postfix/*	4 7 4
      /usr/lib/rpm/**		4 8 6
      /usr/lib/rpm/gnupg/**	4 9 0
      /usr/lib/apache2**	4 7 4
      /usr/lib/mailman/**	4 6 4
      /usr/bin/ldd		1 7 4
      /usr/bin/netcat		5 7 8
      /usr/bin/clear		2 6 3
      /usr/bin/reset		2 6 3
      /usr/bin/tput		2 6 3
      /usr/bin/tset		2 6 3
      /usr/bin/file		2 6 3
      /usr/bin/ftp		3 7 5
      /usr/bin/busybox	4 8 6
      /usr/bin/rbash		4 8 5
      /usr/bin/screen		3 6 5
      /usr/bin/getfacl	3 7 4
      /usr/bin/setfacl	3 7 9
      /usr/bin/*awk*		3 7 7
      /usr/bin/sudo		2 9 10
      /usr/bin/lsattr		2 6 5
      /usr/bin/chattr		2 7 8
      /usr/bin/sed		3 7 6
      /usr/bin/grep		2 7 2
      /usr/bin/chroot		2 6 10
      /usr/bin/dircolors	2 9 3
      /usr/bin/cut		2 7 2
      /usr/bin/du		2 7 3
      /usr/bin/env		2 7 2
      /usr/bin/head		2 7 2
      /usr/bin/tail		2 7 2
      /usr/bin/install	2 8 4
      /usr/bin/link		2 6 4
      /usr/bin/logname	2 6 2
      /usr/bin/md5sum		2 8 3
      /usr/bin/mkfifo		2 6 10
      /usr/bin/nice		2 7 7
      /usr/bin/nohup		2 7 7
      /usr/bin/printf		2 7 1
      /usr/bin/readlink	2 7 3
      /usr/bin/seq		2 7 1
      /usr/bin/sha1sum	2 8 3
      /usr/bin/shred		2 7 3
      /usr/bin/sort		2 7 3
      /usr/bin/split		2 7 3
      /usr/bin/stat		2 7 4
      /usr/bin/sum		2 8 3
      /usr/bin/tac		2 7 3
      /usr/bin/tail		3 8 4
      /usr/bin/tee		2 7 3
      /usr/bin/test		2 8 4
      /usr/bin/touch		2 7 3
      /usr/bin/tr		2 8 3
      /usr/bin/tsort		2 7 3
      /usr/bin/tty		2 7 3
      /usr/bin/unexpand	2 7 3
      /usr/bin/uniq		2 7 3
      /usr/bin/unlink		2 8 4
      /usr/bin/uptime		2 7 3
      /usr/bin/users		2 8 4
      /usr/bin/vdir		2 8 4
      /usr/bin/wc		2 7 3
      /usr/bin/who		2 8 4
      /usr/bin/whoami		2 8 4
      /usr/bin/yes		1 6 1
      /usr/bin/ed		2 7 5
      /usr/bin/red		2 7 4
      /usr/bin/find		2 8 5
      /usr/bin/xargs		2 7 5
      /usr/bin/ispell		2 7 4
      /usr/bin/a2p		2 7 5
      /usr/bin/perlcc		2 7 5
      /usr/bin/perldoc	2 7 5
      /usr/bin/pod2*		2 7 5
      /usr/bin/prove		2 7 5
      /usr/bin/perl		2 10 7
      /usr/bin/perl*		2 10 7
      /usr/bin/suidperl	2 8 8
      /usr/bin/csh		2 8 8
      /usr/bin/tcsh		2 8 8
      /usr/bin/tree		2 6 5
      /usr/bin/last		2 7 5
      /usr/bin/lastb		2 7 5
      /usr/bin/utmpdump	2 6 5
      /usr/bin/alsamixer	2 6 8
      /usr/bin/amixer		2 6 8
      /usr/bin/amidi		2 6 8
      /usr/bin/aoss		2 6 8
      /usr/bin/aplay		2 6 8
      /usr/bin/aplaymidi	2 6 8
      /usr/bin/arecord	2 6 8
      /usr/bin/arecordmidi	2 6 8
      /usr/bin/aseqnet	2 6 8
      /usr/bin/aserver	2 6 8
      /usr/bin/iecset		2 6 8
      /usr/bin/rview		2 6 5
      /usr/bin/ex		2 7 5
      /usr/bin/enscript	2 6 5
      /usr/bin/genscript	2 6 5
      /usr/bin/xdelta		2 6 5
      /usr/bin/edit		2 6 5
      /usr/bin/vimtutor	2 6 5
      /usr/bin/rvim		2 6 5
      /usr/bin/vim		2 8 7
      /usr/bin/vimdiff	2 8 7
      /usr/bin/aspell		2 6 5
      /usr/bin/xxd		2 6 5
      /usr/bin/spell		2 6 5
      /usr/bin/eqn		2 6 5
      /usr/bin/eqn2graph	2 6 5
      /usr/bin/word-list-compress	2 6 4
      /usr/bin/afmtodit	2 6 4
      /usr/bin/hpf2dit	2 6 4
      /usr/bin/geqn		2 6 4
      /usr/bin/grn		2 6 4
      /usr/bin/grodvi		2 6 4
      /usr/bin/groff		2 6 5
      /usr/bin/groffer	2 6 4
      /usr/bin/grolj4		2 6 4
      /usr/bin/grotty		2 6 4
      /usr/bin/gtbl		2 6 4
      /usr/bin/pic2graph	2 6 4
      /usr/bin/indxbib	2 6 4
      /usr/bin/lkbib		2 6 4
      /usr/bin/lookbib	2 6 4
      /usr/bin/mmroff		2 6 4
      /usr/bin/neqn	  2 6 4
      /usr/bin/pfbtops	2 6 4
      /usr/bin/pic		2 6 4
      /usr/bin/tfmtodit	2 6 4
      /usr/bin/tbl		2 6 4
      /usr/bin/post-grohtml	2 6 4
      /usr/bin/pre-grohtml	2 6 4
      /usr/bin/refer		2 6 4
      /usr/bin/soelim		2 6 4
      /usr/bin/disable-paste	2 6 6
      /usr/bin/troff		2 6 4
      /usr/bin/strace-graph	2 6 4
      /usr/bin/gpm-root	2 6 7
      /usr/bin/hltest		2 6 7
      /usr/bin/mev		2 6 6
      /usr/bin/mouse-test	2 6 6
      /usr/bin/strace		2 8 9
      /usr/bin/scsiformat	2 7 10
      /usr/bin/lsscsi		2 7 7
      /usr/bin/scsiinfo	2 7 7
      /usr/bin/sg_*		2 7 7
      /usr/bin/build-classpath		2 6 6
      /usr/bin/build-classpath-directory	2 6 6
      /usr/bin/build-jar-repository		2 6 6
      /usr/bin/diff-jars			2 6 6
      /usr/bin/jvmjar				2 6 6
      /usr/bin/rebuild-jar-repository		2 6 6
      /usr/bin/scriptreplay	2 6 5
      /usr/bin/cal		2 6 3
      /usr/bin/chkdupexe	2 6 5
      /usr/bin/col		2 6 4
      /usr/bin/colcrt		2 6 4
      /usr/bin/colrm		2 6 3
      /usr/bin/column		2 6 4
      /usr/bin/cytune		2 6 6
      /usr/bin/ddate		2 6 3
      /usr/bin/fdformat	2 6 6
      /usr/bin/getopt		2 8 6
      /usr/bin/hexdump	2 6 4
      /usr/bin/hostid		2 6 4
      /usr/bin/ipcrm		2 7 7
      /usr/bin/ipcs		2 7 6
      /usr/bin/isosize	2 6 4
      /usr/bin/line		2 6 4
      /usr/bin/look		2 6 5
      /usr/bin/mcookie	2 7 5
      /usr/bin/mesg		2 6 4
      /usr/bin/namei		2 6 5
      /usr/bin/rename		2 6 5
      /usr/bin/renice		2 6 7
      /usr/bin/rev		2 6 5
      /usr/bin/script		2 6 6
      /usr/bin/ChangeSymlinks	2 8 8
      /usr/bin/setfdprm	2 6 7
      /usr/bin/setsid		2 6 3
      /usr/bin/setterm	2 6 5
      /usr/bin/tailf		2 6 4
      /usr/bin/time		2 6 4
      /usr/bin/ul		2 6 4
      /usr/bin/wall		2 6 5
      /usr/bin/whereis	2 6 4
      /usr/bin/which		2 6 3
      /usr/bin/c_rehash	2 7 6
      /usr/bin/openssl	2 8 6
      /usr/bin/lsdev		2 6 5
      /usr/bin/procinfo	2 6 5
      /usr/bin/socklist	2 6 5
      /usr/bin/filesize	2 6 3
      /usr/bin/linkto		2 6 3
      /usr/bin/mkinfodir	2 6 5
      /usr/bin/old		2 6 4
      /usr/bin/rpmlocate	2 6 5
      /usr/bin/safe-rm	2 8 6
      /usr/bin/safe-rmdir	2 8 6
      /usr/bin/setJava	2 6 1
      /usr/bin/vmstat		2 6 4
      /usr/bin/top		2 6 6
      /usr/bin/pinentry*	2 7 6
      /usr/bin/free		2 8 4
      /usr/bin/pmap		2 6 5
      /usr/bin/slabtop	2 6 4
      /usr/bin/tload		2 6 4
      /usr/bin/watch		2 6 3
      /usr/bin/w		2 6 4
      /usr/bin/pstree.x11	2 6 4
      /usr/bin/pstree		2 6 4
      /usr/bin/snice		2 6 6
      /usr/bin/skill		2 6 7
      /usr/bin/pgrep		2 6 4
      /usr/bin/killall	2 6 7
      /usr/bin/curl		2 7 7
      /usr/bin/slptool	2 7 8
      /usr/bin/ldap*		2 7 7
      /usr/bin/whatis		2 7 5
     '';

     # Enable logging to /var/log/messages so that
     # aa-logprof can parse the text logfiles
     services.journald.forwardToSyslog = true;
     services.rsyslogd = {
       enable = true;
       extraConfig = ''
         $ModLoad imklog
         kern.*			     -/var/log/messages
       '';
     };
     boot.kernelParams = [ "apparmor=1" "security=apparmor" ];

     systemd.services.apparmor = let
       paths = concatMapStrings (s: " -I ${s}/etc/apparmor.d")
         ([ pkgs.apparmor-profiles ] ++ cfg.packages);
     in {
       after = [ "local-fs.target" ];
       before = [ "sysinit.target" ];
       wantedBy = [ "multi-user.target" ];
       unitConfig = {
         DefaultDependencies = "no";
       };
       serviceConfig = {
         Type = "oneshot";
         RemainAfterExit = "yes";
         ExecStart = map (p:
           ''${pkgs.apparmor-parser}/bin/apparmor_parser -rKv ${paths} "${p}"''
         ) cfg.profiles;
         ExecStop = map (p:
           ''${pkgs.apparmor-parser}/bin/apparmor_parser -Rv "${p}"''
         ) cfg.profiles;
         ExecReload = map (p:
           ''${pkgs.apparmor-parser}/bin/apparmor_parser --reload ${paths} "${p}"''
         ) cfg.profiles;
       };
     };
   };
}
