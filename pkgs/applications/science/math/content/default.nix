a :  
let 
  fetchurl = a.fetchurl;

  version = "1.5"; 
  buildInputs = with a; [
    mesa lesstif libX11 libXaw xproto libXt libSM libICE 
      libXmu libXext libXcursor
  ];
in
rec {
  srcNcbiStdH = fetchurl {
    url = "http://www.math.uu.nl/people/kuznet/CONTENT/src/unix/ncbistd.h";
    sha256 = "1zi3l53b0a7d3620rhxvh1jn7pz3ihl1mxl9qqw86xkmhm4q7xf3";
  };

  srcVibrant = fetchurl {
    url = "http://www.math.uu.nl/people/kuznet/CONTENT/src/unix/vibrant.tar.gz";
    sha256 = "1s0vsa0np3sm7jh3ps3f1sf4j64v0kw4hqasllpxx5hdgxwd8y25";
  };

  srcContent = fetchurl {
    url = "http://www.math.uu.nl/people/kuznet/CONTENT/src/unix/content_${version}.tar.gz";
    sha256 = "0y0dzr1d3jgbd53729jk6s2wpb5hv54xwbdird4r0s15bznpm6fs";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["unpackTarballs" 
    "setPlatform" "extraVars"
    "buildVibrant" "buildContent" 
    "install"];

  unpackTarballs = a.fullDepEntry (''
    mkdir content
    cd content
    mkdir vibrant
    tar -xvf ${srcVibrant} -C vibrant
    tar -xvf ${srcContent} -C .
    sed -e s/SGI=/SGI=no/ -i content/makefile_v
  '') ["minInit"];

  platformTLAContent = if a.stdenv.isLinux then "LIN" else 
    throw "Three-letter code for the platform is not known";

  platformTLAVibrant = if a.stdenv.isLinux then "lnx" else 
    throw "Three-letter code for the platform is not known";

  setPlatform = a.fullDepEntry (''
    sed -e 's/${platformTLAContent}=no/${platformTLAContent}=/' -i content/makefile_v
  '') ["minInit" "unpackTarballs"];

  extraVars = a.noDepEntry ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXcursor"
  '';

  buildVibrant = a.fullDepEntry (''
    cd vibrant/build
    
    export LCL=${platformTLAVibrant}
    make copy
    for i in *.c; do gcc $i -c -DWIN_MOTIF -I. -I../include; done
    sh ../make/viball.${platformTLAVibrant}

    cd ../..
  '') ["addInputs" "unpackTarballs"];

  buildContent = a.fullDepEntry (''
    cd content 

    export PATH=$PATH:$PWD/victor:$PWD/yuri
    make -f makefile_v unix
    
    cd ..
  '') ["addInputs" "buildVibrant" "setPlatform"];

  install = a.fullDepEntry (''
    mkdir -p $out/share/${name}/build-snapshot $out/bin $out/lib $out/share/${name}/doc
    find . -name '*.o' -exec cp '{}' $out/lib ';'
    find . -name '*.so' -exec cp '{}' $out/lib ';'
    find . -name '*.txt' -exec cp '{}' $out/share/${name}/doc ';'
    find . -name '*.hlp' -exec cp '{}' $out/share/${name}/doc ';'
    find . -perm +111 -a ! -name '*.*' -exec cp '{}' $out/bin ';'
    cp -r . $out/share/${name}/build-snapshot
  '') ["buildContent" "defEnsureDir" "minInit"];
      
  name = "content-" + version;
  meta = {
    description = "A tool for analysis of dynamical systems";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = a.lib.platforms.linux;
    broken = true;
  };
}
