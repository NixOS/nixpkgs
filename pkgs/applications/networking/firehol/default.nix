{ stdenv, lib, fetchFromGitHub, pkgs
, autoconf, automake, curl, iprange, iproute, ipset, iptables, iputils
, kmod, nettools, procps, tcpdump, traceroute, util-linux, whois

# If true, just install FireQOS without FireHOL
, onlyQOS ? false
}:

stdenv.mkDerivation rec {
  pname = "firehol";
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
    ./firehol-ping6.patch

    # put firehol config files in /etc/firehol (not $out/etc/firehol)
    # to avoid error on startup, see #35114
    ./firehol-sysconfdir.patch

    # we must quote "$UNAME_CMD", or the dash in
    # /nix/store/...-coreutils-.../bin/uname will be interpreted as
    # IFS -> error. this might be considered an upstream bug but only
    # appears when there are dashes in the command path
    ./firehol-uname-command.patch
  ];

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [
    curl iprange iproute ipset iptables iputils kmod
    nettools procps tcpdump traceroute util-linux whois
  ];

  preConfigure = "./autogen.sh";
  configureFlags = [ "--localstatedir=/var"
                     "--disable-doc" "--disable-man" ] ++
                   lib.optional onlyQOS [ "--disable-firehol" ];

  meta = with lib; {
    description = "A firewall for humans";
    longDescription = ''
      FireHOL, an iptables stateful packet filtering firewall for humans!
      FireQOS, a TC based bandwidth shaper for humans!
    '';
    homepage = "https://firehol.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ oxzi ];
    platforms = platforms.linux;
  };
}
