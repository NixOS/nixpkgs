{
  lib,
  stdenv,
  fetchurl,
  lynx,
}:

stdenv.mkDerivation rec {
  pname = "ifmetric";
  version = "0.3";

  src = fetchurl {
    url = "https://0pointer.de/lennart/projects/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [ lynx ];

  patches = [
    # Fixes an issue related to the netlink API.
    # Upstream is largely inactive; this is a Debian patch.
    (fetchurl {
      url = "https://launchpadlibrarian.net/85974387/10_netlink_fix.patch";
      sha256 = "1pnlcr0qvk0bd5243wpg14i387zp978f4xhwwkcqn1cir91x7fbc";
    })
  ];

  meta = with lib; {
    description = "Tool for setting IP interface metrics";
    longDescription = ''
      ifmetric is a Linux tool for setting the metrics of all IPv4 routes
      attached to a given network interface at once. This may be used to change
      the priority of routing IPv4 traffic over the interface. Lower metrics
      correlate with higher priorities.
    '';
    homepage = "http://0pointer.de/lennart/projects/ifmetric";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.anna328p ];
    platforms = platforms.linux;
    mainProgram = "ifmetric";
  };
}
