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
      url    = url + "/v0.1.1-dev/saw-0.1.1-dev-2015-07-31-CentOS6-32.tar.gz";
      sha256 = "126iag5nnvndi78c921z7vjrjfwcspn1hlxwwhzmqm4rvbhhr9v9";
    }
    else fetchurl {
      url    = url + "/v0.1.1-dev/saw-0.1.1-dev-2015-07-31-CentOS6-64.tar.gz";
      sha256 = "07gyf319v6ama6n1aj96403as04bixi8mbisfy7f7va689zklflr";
    };
in
stdenv.mkDerivation rec {
  name    = "saw-tools-${version}";
  version = "0.1.1-20150731";

  src = saw-bin;

  installPhase = ''
    mkdir -p $out/lib $out/share

    mv bin $out/bin
    mv doc $out/share

    # Hack around lack of libtinfo in NixOS
    ln -s ${ncurses.out}/lib/libncursesw.so.5       $out/lib/libtinfo.so.5
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
