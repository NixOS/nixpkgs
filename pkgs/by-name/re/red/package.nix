{ lib, stdenv, stdenv_32bit, pkgsi686Linux, fetchFromGitHub, fetchurl }:

stdenv.mkDerivation rec {
  pname = "red";
  version = "0.6.4";
  src = fetchFromGitHub {
    rev = "755eb943ccea9e78c2cab0f20b313a52404355cb";
    owner = "red";
    repo = "red";
    sha256 = "sha256:045rrg9666zczgrwyyyglivzdzja103s52b0fzj7hqmr1fz68q37";
  };

  rebol = fetchurl {
    url = "http://www.rebol.com/downloads/v278/rebol-core-278-4-2.tar.gz";
    sha256 = "1c1v0pyhf3d8z98qc93a5zmx0bbl0qq5lr8mbkdgygqsq2bv2xbz";
  };

  buildInputs = [ pkgsi686Linux.curl stdenv_32bit ];

  r2 = "./rebol/releases/rebol-core/rebol";

  configurePhase = ''
    # Download rebol
    mkdir rebol/
    tar -xzvf ${rebol} -C rebol/
    patchelf --set-interpreter \
        ${stdenv_32bit.cc.libc.out}/lib/32/ld-linux.so.2 \
        ${r2}
  '';

  buildPhase = ''
    # Do tests
    #${r2} -qw run-all.r

    # Build test
    ${r2} -qw red.r tests/hello.red

    # Compiling the Red console...
    ${r2} -qw red.r -r environment/console/CLI/console.red

    # Generating docs...
    cd docs
    ../${r2} -qw makedoc2.r red-system-specs.txt
    ../${r2} -qw makedoc2.r red-system-quick-test.txt
    cd ../
  '';

  installPhase = ''
    mkdir $out

    # Install
    install -d $out/opt/red
    find quick-test -type f -executable -print0 | xargs -0 rm
    cp -R * $out/opt/red/
    rm -rf $out/opt/red/rebol
    install -Dm755 console $out/bin/red
    install -Dm644 BSD-3-License.txt                          \
        $out/share/licenses/${pname}-${version}/BSD-3-License.txt
    install -Dm644 BSL-License.txt                            \
        $out/share/licenses/${pname}-${version}/BSL-License.txt
    install -Dm644 docs/red-system-quick-test.html            \
        $out/share/doc/${pname}-${version}/red-system-quick-test.html
    install -Dm644 docs/red-system-specs.html                 \
        $out/share/doc/${pname}-${version}/red-system-specs.html

    # PathElf
    patchelf --set-interpreter                            \
        ${stdenv_32bit.cc.libc.out}/lib/32/ld-linux.so.2  \
        $out/opt/red/console
    patchelf --set-rpath ${pkgsi686Linux.curl.out}/lib \
        $out/opt/red/console
    patchelf --set-interpreter                            \
        ${stdenv_32bit.cc.libc.out}/lib/32/ld-linux.so.2  \
        $out/bin/red
    patchelf --set-rpath ${pkgsi686Linux.curl.out}/lib \
        $out/bin/red

  '';

  meta = with lib; {
    description = ''
      New programming language strongly inspired by Rebol, but with a
      broader field of usage thanks to its native-code compiler, from system
      programming to high-level scripting, while providing modern support for
      concurrency and multi-core CPUs
    '';
    mainProgram = "red";
    maintainers = with maintainers; [ uralbash ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.bsd3;
    homepage = "https://www.red-lang.org/";
  };
}
