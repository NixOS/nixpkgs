args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  fullDepEntry = args.fullDepEntry;

  version = lib.attrByPath ["version"] "3.3.0" args; 
  _buildInputs = with args; [
    python e2fsprogs gnutls pkgconfig libjpeg 
    ncurses SDL libvncserver zlib graphviz ghostscript 
    texLive
  ];
in
rec {
  src = fetchurl {
    url = "http://bits.xensource.com/oss-xen/release/${version}/xen-${version}.tar.gz";
    sha256 = "0vghm31pqq8sc6x81jass2h5s22jlvv582xb8aq4j4cbcc5qixc9";
  };

  buildInputs = lib.filter (x: x != null) _buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["makeTools" "makeXen"];

  makeTools = fullDepEntry (''make -C tools install PREFIX=$out '') 
    ["minInit" "addInputs" "doUnpack"];
      
  makeXen = fullDepEntry (''make -C xen install PREFIX=$out '') 
    ["minInit" "addInputs" "doUnpack"];
      
  name = "xen-" + version;
  meta = {
    description = "Xen paravirtualization tools";
  };
}
