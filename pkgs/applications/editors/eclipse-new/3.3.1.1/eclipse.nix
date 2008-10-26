# Note, if you want to install plugins using the update manager you should
# copy the store path to a local directory and chown -R $USER yourcopy
# Then start your local copy

args: with args;
let arch = if stdenv.system == "x86_64-linux" then "x86_64"
            else if stdenv.system == "i686-linux" then "x86"
            else throw "not supported system";
in
args.stdenv.mkDerivation rec {
  #name = "eclipse-classic-3.4M5";
  name = "eclipse-classic-3.3.1.1";

  unpackPhase = "unzip \$src;     set -x ";
  buildInputs = [ unzip jdk gtk glib libXtst ant  makeWrapper];


  patches=./build-with-jdk-compiler.patch;

  buildPhase = "./build -os linux -ws gtk -arch ${arch}";
  
  libraries = [gtk glib libXtst];

  installPhase = "
    t=\$out/share/${name}
    ensureDir \$t \$out/bin
    cd result
    tar xfz linux-gtk-*.tar.gz
    mv eclipse \$out
    "
    #copied from other eclipse expressions
    +" rpath=
    for i in \$libraries; do
        rpath=\$rpath\${rpath:+:}\$i/lib
    done
    find \$out \\( -type f -a -perm +0100 \\) \\
        -print \\
        -exec patchelf --interpreter \"$(cat \$NIX_GCC/nix-support/dynamic-linker)\" \\
        --set-rpath \"\$rpath\" {} \\;

    # Make a wrapper script so that the proper JDK is found.
    makeWrapper \$out/eclipse/eclipse \$out/bin/eclipse \\
        --prefix PATH \":\" \"\$jdk/bin\" \\
        --prefix LD_LIBRARY_PATH \":\" \"\$rpath\"
    sed -e 's=exec.*=exec \$(dirname $0)/../eclipse/eclipse $@=' -i \$out/bin/eclipse
  ";
  # using dirname so that eclipse still runs after copying the whole store
  # directory somewhere else (so that you can use the update manager

  src = args.fetchurl {
    #url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/eclipse/downloads/drops/S-3.4M5-200802071530/eclipse-sourceBuild-srcIncluded-3.4M5.zip;
    #sha256 = "1w6fbpwkys65whygc045556772asggj24x8assnaba6nl70z00az";

    url = http://download.micromata.de/eclipse/eclipse/downloads/drops/R-3.3.1.1-200710231652/eclipse-sourceBuild-srcIncluded-3.3.1.1.zip;
    sha256 = "0n56i7ml816f839704qlkgs5ahl0iqgwc80kjq7n7g5rl9a4vhp4";
  };
}
