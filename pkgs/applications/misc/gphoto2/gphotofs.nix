a :  
let 
  fetchurl = a.fetchurl;
  s = import ./src-info-for-gphotofs.nix;

  version = a.lib.attrByPath ["version"] s.version a; 
  buildInputs = with a; [
    libgphoto2 fuse pkgconfig glib
  ];
in
rec {
  src = fetchurl {
    url = s.url;
    sha256 = s.hash;
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "gphoto2fs-" + version;
  meta = {
    description = "Fuse FS to mount a digital camera";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = [
      "i686-linux" "x86_64-linux"
    ];
  };
}
