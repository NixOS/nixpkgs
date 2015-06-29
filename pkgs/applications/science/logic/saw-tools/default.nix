{ stdenv, fetchurl, gmp4, ncurses, zlib, makeWrapper, clang_35 }:

let
  libPath = stdenv.lib.makeLibraryPath
    [ stdenv.cc.libc
      stdenv.cc.cc
      gmp4
      ncurses
      zlib
    ] + ":${stdenv.cc.cc}/lib64";

  url = "https://github.com/GaloisInc/saw-script/releases/download";

  saw-bin =
    if stdenv.system == "i686-linux"
    then fetchurl {
      url    = url + "/v0.1-dev/saw-0.1-dev-2015-06-09-CentOS6-32.tar.gz";
      sha256 = "0hfb3a749fvwn33jnj1bgpk7v4pbvjjjffhafck6s8yz2sknnq4w";
    }
    else fetchurl {
      url    = url + "/v0.1-dev/saw-0.1-dev-2015-06-09-CentOS6-64.tar.gz";
      sha256 = "1yz56kr8s0jcrfk1i87x63ngxip2i1s123arydnqq8myjyfz8id9";
    };
in
stdenv.mkDerivation rec {
  name    = "saw-tools-${version}";
  version = "0.1-20150609";

  src = saw-bin;

  installPhase = ''
    mkdir -p $out/lib $out/share

    mv bin $out/bin
    mv doc $out/share

    # Hack around lack of libtinfo in NixOS
    ln -s ${ncurses}/lib/libncursesw.so.5       $out/lib/libtinfo.so.5
    ln -s ${stdenv.cc.libc}/lib/libpthread.so.0 $out/lib/libpthread.so.0

    # Add a clang symlink for easy building with a suitable compiler.
    ln -s ${clang_35}/bin/clang $out/bin/saw-clang
  '';

  fixupPhase = ''
    for x in bin/bcdump bin/extcore-info bin/jss bin/llvm-disasm bin/lss bin/saw; do
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$out/lib:${libPath}" $out/$x;
    done
  '';

  phases = "unpackPhase installPhase fixupPhase";

  meta = {
    description = "Tools for software verification and analysis";
    homepage    = "https://saw.galois.com";
    license     = stdenv.lib.licenses.unfreeRedistributable;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
