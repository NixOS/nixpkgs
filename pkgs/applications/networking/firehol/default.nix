{ stdenv, lib, fetchFromGitHub, pkgs
, autoconf, automake, curl, iprange, iproute, ipset, iptables, iputils
, kmod, nettools, procps, tcpdump, traceroute, utillinux, whois

# If true, just install FireQOS without FireHOL
, onlyQOS ? false
}:

stdenv.mkDerivation rec {
  name = "firehol-${version}";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "firehol";
    repo = "firehol";
    rev = "v${version}";
    sha256 = "0l7sjpsb300kqv21hawd26a7jszlmafplacpn5lfj64m4yip93fd";
  };

  patches = [
    # configure tries to determine if `ping6` or the newer, combined
    # `ping` is installed by using `ping -6` which would fail.
    (pkgs.writeText "firehol-ping6.patch"
      ''
      --- a/m4/ax_check_ping_ipv6.m4
      +++ b/m4/ax_check_ping_ipv6.m4
      @@ -42,16 +42,16 @@ AC_DEFUN([AX_CHECK_PING_IPV6],

           AC_CACHE_CHECK([whether ]PING[ has working -6 option], [ac_cv_ping_6_opt],
           [
      -        ac_cv_ping_6_opt=no
      -        if test -n "$PING"; then
      -            echo "Trying '$PING -6 -c 1 ::1'" >&AS_MESSAGE_LOG_FD
      -            $PING -6 -c 1 ::1 > conftest.out 2>&1
      -            if test "$?" = 0; then
      -                ac_cv_ping_6_opt=yes
      -            fi
      -            cat conftest.out >&AS_MESSAGE_LOG_FD
      -            rm -f conftest.out
      -        fi
      +        ac_cv_ping_6_opt=yes
      +        #if test -n "$PING"; then
      +        #    echo "Trying '$PING -6 -c 1 ::1'" >&AS_MESSAGE_LOG_FD
      +        #    $PING -6 -c 1 ::1 > conftest.out 2>&1
      +        #    if test "$?" = 0; then
      +        #        ac_cv_ping_6_opt=yes
      +        #    fi
      +        #    cat conftest.out >&AS_MESSAGE_LOG_FD
      +        #    rm -f conftest.out
      +        #fi
           ])

           AS_IF([test "x$ac_cv_ping_6_opt" = "xyes"],[
      '')

    # put firehol config files in /etc/firehol (not $out/etc/firehol)
    # to avoid error on startup, see #35114
    (pkgs.writeText "firehol-sysconfdir.patch"
      ''
      --- a/sbin/install.config.in.in
      +++ b/sbin/install.config.in.in
      @@ -4 +4 @@
      -SYSCONFDIR="@sysconfdir_POST@"
      +SYSCONFDIR="/etc"
      '')

    # we must quote "$UNAME_CMD", or the dash in /nix/store/...-coreutils-.../bin/uname
    # will be interpreted as IFS -> error. this might be considered an upstream bug
    # but only appears when there are dashes in the command path
    (pkgs.writeText "firehol-uname-command.patch"
      ''
      --- a/sbin/firehol
      +++ b/sbin/firehol
      @@ -10295,7 +10295,7 @@
       	kmaj=$1
       	kmin=$2
       
      -	set -- $($UNAME_CMD -r)
      +	set -- $("$UNAME_CMD" -r)
       	eval $kmaj=\$1 $kmin=\$2
       }
       kernel_maj_min KERNELMAJ KERNELMIN
      '')
  ];
  
  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [
    curl iprange iproute ipset iptables iputils kmod
    nettools procps tcpdump traceroute utillinux whois
  ];

  preConfigure = "./autogen.sh";
  configureFlags = [ "--localstatedir=/var"
                     "--disable-doc" "--disable-man" ] ++
                   lib.optional onlyQOS [ "--disable-firehol" ];

  meta = with stdenv.lib; {
    description = "A firewall for humans";
    longDescription = ''
      FireHOL, an iptables stateful packet filtering firewall for humans!
      FireQOS, a TC based bandwidth shaper for humans!
    '';
    homepage = https://firehol.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ geistesk ];
    platforms = platforms.linux;
  };
}
