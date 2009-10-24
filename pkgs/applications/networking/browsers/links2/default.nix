a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    libpng libjpeg bzip2 zlib libtiff
    directfb libX11 libXau xproto gpm
    openssl libXt pkgconfig
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [
    "--enable-graphics"
    "--with-ssl"
    "--with-x"
    "--with-fb"
    ];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  meta = {
    description = "A small browser with some graphics support";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}
