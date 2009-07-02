args: with args;

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "firefox-3b1";

  src = 
	fetchurl {
		url = ftp://ftp.mozilla.org/pub/firefox/releases/3.0b1/linux-i686/en-US/firefox-3.0b1.tar.bz2;
		sha256 = "1cpcc5b07zdqyd5kiwhb4dqhy2mzbf97plsglcp6bc9054cmsylk";
	};
  buildInputs = [
    pkgconfig gtk perl zip libIDL libXi libjpeg libpng zlib cairo
    python curl coreutils atk pango glib libX11 libXrender 
    freetype fontconfig libXft libXt
  ];

  buildPhase = "
    additionalRpath='';
    for i in \$buildInputs ${stdenv.glibc} ${stdenv.gcc.gcc}; do 
      additionalRpath=\$additionalRpath:\$i/lib;  
    done
    for i in firefox-bin ; do
      oldrpath=$(patchelf --print-rpath \$i)
      patchelf --set-rpath \$oldrpath\$additionalRpath \$i
      patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux.so.2 \$i
    done
  ";

  installPhase = "
    export dontPatchELF=1;
    mkdir -p \$out
    cp -r . \$out/firefox
    mkdir -p \$out/bin
    ln -s \$out/firefox/firefox \$out/bin/firefox

    sed -e 's@moz_libdir=.*@moz_libdir='\$out'/firefox/@' -i \$out/bin/firefox 
    sed -e 's@moz_libdir=.*@&\\nexport PATH=\$PATH:${coreutils}/bin@' -i \$out/bin/firefox 
    sed -e 's@`/bin/pwd@`${coreutils}/bin/pwd@' -i \$out/bin/firefox 
    sed -e 's@`/bin/ls@`${coreutils}/bin/ls@' -i \$out/bin/firefox 

    strip -S \$out/firefox/*.so || true

    echo \"running firefox -register...\"
    \$out/firefox/firefox-bin -register || false
  ";

  meta = {
    description = "Mozilla Firefox - the browser, reloaded";
  };

  passthru = {inherit gtk;};
}

