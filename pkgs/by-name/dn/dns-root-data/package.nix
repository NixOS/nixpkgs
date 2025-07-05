{
  stdenv,
  lib,
  fetchurl,
}:

let
  rootHints = fetchurl {
    # Original source https://www.internic.net/domain/named.root
    # occasionally suffers from pointless hash changes,
    # and having stable sources for older versions has advantages, too.
    urls = map (prefix: prefix + "d9c96ae96f066a85d7/etc/root.hints") [
      "https://gitlab.nic.cz/knot/knot-resolver/raw/"
      "https://raw.githubusercontent.com/CZ-NIC/knot-resolver/"
    ];
    hash = "sha256-4lG/uPnNHBNIZ/XIeDM1w3iukrpeW0JIjTnGSwkJ8U4=";
  };
in
stdenv.mkDerivation {
  pname = "dns-root-data";
  version = "2025-04-14";

  buildCommand = ''
    mkdir $out
    cp ${rootHints} $out/root.hints
    cp ${./root.key} $out/root.key
    cp ${./root.ds} $out/root.ds
  '';

  meta = with lib; {
    homepage = "https://www.iana.org/domains/root/files";
    description = "DNS root data including root hints and DNSSEC root trust anchor + key";
    maintainers = with maintainers; [
      fpletz
      vcunat
    ];
    license = licenses.gpl3Plus;
  };
}
