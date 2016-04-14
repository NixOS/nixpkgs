{ lib, ... }:
with lib;
{
  options = {

    flyingcircus.static = mkOption {
      type = types.attrsOf types.attrs;
      default = { };
      description = "Static lookup tables for site-specific information";
    };

  };

  config = {
    flyingcircus.static.vlans = {
      "1" = "mgm";
      "2" = "fe";
      "3" = "srv";
      "4" = "sto";
      "5" = "ws";
      "6" = "tr";
      "7" = "gue";
      "8" = "stb";
      "14" = "tr2";
      "15" = "gocept";
      "16" = "fe2";
      "17" = "srv2";
      "18" = "tr3";
    };

    flyingcircus.static.nameservers = {
      # ns.$location.gocept.net, ns2.$location.gocept.net
      # We are currently not using IPv6 resolvers as we have seen obscure bugs
      # when enabling them, like weird search path confusion that results in
      # arbitrary negative responses, combined with the rotate flag.
      #
      # This seems to be https://sourceware.org/bugzilla/show_bug.cgi?id=13028
      # which is fixed in glibc 2.22 which is included in NixOS 16.03.
      dev = ["172.30.3.10" "172.20.2.38"];
      rzob = ["195.62.125.5" "195.62.125.135"];
      rzrl1 = ["172.24.32.3" "172.24.48.4"];
      whq = ["212.122.41.143" "212.122.41.169"];

      # We'd like to add reliable open and trustworthy DNS servers here, but
      # I didn't find reliable ones. FoeBud and Germany Privacy Foundation and
      # others had long expired listings and I don't trust the remaining ones
      # to stay around. So, Google DNS it is.
      standalone = [ "8.8.8.8" "8.8.4.4" ];
    };

    flyingcircus.static.ntpservers = {
      # Those are the routers and ceph mons. This needs to move to the
      # directory service discovery.
      dev = [ "selma" "barney" "eddie" "sherri" "cartman02" "patty"];
      rzob = [ "carme" "cartman07" "cartman11" "kenny00" "cartman12" "kenny01" "cartman10" "iocaste" "cartman13" "cartman08" "cartman06" ];
      rzrl1 = [ "kyle04" "kenny03" "kenny02" "cartman04" "cartman05" ];
      whq = [ "barbrady01" "cartman00" "kyle03" "terri" "edna" "hibbert" "bob" "lou" ];

      # Location-independent NTP servers from the global public pool.
      standalone = [ "0.pool.ntp.org"
                     "1.pool.ntp.org"
                     "2.pool.ntp.org"
                     "3.pool.ntp.org"];
    };

    # Generally allow DHCP?
    flyingcircus.static.allowDHCP = {
      dev = false;
      rzob = false;
      rzrl1 = false;
      standalone = true;
      vagrant = true;
      whq = false;
    };

  };
}
