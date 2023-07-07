{ lib, stdenv, requireFile, unzip, rlwrap, bash, zlib }:

assert (stdenv.hostPlatform.system == "i686-linux");

let
  libPath = lib.makeLibraryPath
    [ stdenv.cc.libc stdenv.cc.cc zlib ];
in
stdenv.mkDerivation rec {
  pname = "kdbplus";
  version = "3.6";

  src = requireFile rec {
    message = ''
      Nix can't download kdb+ for you automatically. Go to
      http://kx.com and download the free, 32-bit version for
      Linux. Then run "nix-prefetch-url file://\$PWD/${name}" in
      the directory where you saved it. Note you need version ${version}.
    '';
    name   = "linuxx86.zip";
    sha256 = "0w6znd9warcqx28vf648n0vgmxyyy9kvsfpsfw37d1kp5finap4p";
  };

  dontStrip = true;
  nativeBuildInputs = [ unzip ];

  phases = "unpackPhase installPhase";
  unpackPhase = "mkdir ${pname}-${version} && cd ${pname}-${version} && unzip -qq ${src}";
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
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license     = lib.licenses.unfree;
    platforms   = [ "i686-linux" ];
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
