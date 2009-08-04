a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "2.07" a; 
  buildInputs = with a; [
    libjpeg libexif giflib libtiff libpng
      imagemagick ghostscript which curl 
      pkgconfig freetype fontconfig
  ];
in
rec {
  src = fetchurl {
    url = "http://dl.bytesex.org/releases/fbida/fbida-${version}.tar.gz";
    sha256 = "0i6v3fvjc305pfw48sglb5f22lwxldmfch6mjhqbcp7lqkkxw435";
  };

  inherit buildInputs;
  configureFlags = [];
  makeFlags = [
    "prefix=$out"
    "verbose=yes"
    ];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doMakeInstall" (a.doPatchShebangs "$out/bin")];
      
  name = "fbida-" + version;
  meta = {
    description = "Framebuffer image viewing programs";
    maintainers = [
    ];
  };
}
