{ stdenv, lib, fetchFromGitHub, autoconf, automake, curl, iprange, iproute2, iptables, iputils
, kmod, nettools, procps, tcpdump, traceroute, util-linux, whois

# If true, just install FireQOS without FireHOL
, onlyQOS ? false
}:

stdenv.mkDerivation rec {
  pname = "firehol";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "firehol";
    repo = "firehol";
    rev = "v${version}";
    sha256 = "sha256-gq7l7QoUsK+j5DUn84kD9hlUTC4hz3ds3gNJc1tRygs=";
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
    curl iprange iproute2 iptables iputils kmod
    nettools procps tcpdump traceroute util-linux whois
  ];

  preConfigure = "./autogen.sh";
  configureFlags = [ "--localstatedir=/var"
                     "--disable-doc" "--disable-man"
                     "--disable-update-ipsets" ] ++
                   lib.optionals onlyQOS [ "--disable-firehol" ];

  meta = with lib; {
    description = "Firewall for humans";
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
