{ stdenv, requireFile, unzip, rlwrap, bash }:

assert (stdenv.system == "i686-linux");

let
  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc stdenv.cc.cc ];
in
stdenv.mkDerivation rec {
  name    = "kdbplus-${version}";
  version = "3.3";

  src = requireFile {
    message = ''
      Nix can't download kdb+ for you automatically. Go to
      http://kx.com and download the free, 32-bit version for
      Linux. Then run "nix-prefetch-url file://\$PWD/linux.zip" in
      the directory where you saved it. Note you need version 3.3.
    '';
    name   = "linux.zip";
    sha256 = "5fd0837599e24f0f437a8314510888a86ab0787684120a8fcf592299800aa940";
  };

  dontStrip = true;
  buildInputs = [ unzip ];

  phases = "unpackPhase installPhase";
  unpackPhase = "mkdir ${name} && cd ${name} && unzip -qq ${src}";
  installPhase = ''
    mkdir -p $out/bin $out/libexec

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} \
      ./q/l32/q
    mv ./q/l32/q $out/libexec/q

    # Shell script wrappers to make things more convenient...

    cat > $out/bin/q-install <<- EOF
    #!${bash}/bin/bash
    if [ -f \$HOME/q/q.k ]; then
      echo "kdb has already been unpacked in \$HOME. Skipping..."
      exit 0
    fi
    echo -n "Unzipping ${src} into \$HOME... "
    cd \$HOME && ${unzip}/bin/unzip -qq ${src}
    echo "Done"
    EOF

    cat > $out/bin/q <<- EOF
    #!${bash}/bin/bash
    if [ ! -f \$HOME/q/q.k ]; then
      echo "ERROR: You need to unzip the Q sources into \$HOME before running q."
      echo
      echo "Try:"
      echo "  cd \$HOME && unzip ${src}"
      echo "(or run q-install)"
      exit 1
    fi

    exec ${rlwrap}/bin/rlwrap $out/libexec/q \$@
    EOF

    chmod +x $out/bin/q $out/bin/q-install
  '';

  meta = {
    description = "Analytics and time-series database";
    homepage    = "http://www.kx.com/";
    license     = stdenv.lib.licenses.unfree;
    platforms   = [ "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
