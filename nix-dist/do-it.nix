let {
  system = "i686-suse-linux";
  pkgs = (import ../pkgs/system/all-packages.nix) {system = system};
  stdenv = pkgs.stdenv_;

  sourcedist = (import ./nix-source-dist.nix) {
    stdenv = stdenv;
    autoconf = pkgs.autoconf;
    automake = pkgs.automake;
    libxml2 = pkgs.libxml2;
    libxslt = pkgs.libxslt;
    docbook_dtd = pkgs.docbook_xml_dtd;
    docbook_xslt = pkgs.docbook_xml_xslt;
    fetchurl = pkgs.fetchurl;
    fetchsvn = pkgs.fetchsvn;
    rev = import ./head-revision.nix;
  };

  body = sourcedist;
}