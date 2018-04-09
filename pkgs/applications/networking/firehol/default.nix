{ stdenv, lib, fetchFromGitHub, pkgs
, autoconf, automake, curl, iprange, iproute, ipset, iptables, iputils
, kmod, nettools, procps, tcpdump, traceroute, utillinux, whois

# Just install FireQOS without FireHOL
, onlyQOS ? true
}:

stdenv.mkDerivation rec {
  name = "firehol-${version}";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "firehol";
    repo = "firehol";
    rev = "v${version}";
    sha256 = "15cy1zxfpprma2zkmhj61zzhmw1pfnyhln7pca5lzvr1ifn2d0y0";
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
