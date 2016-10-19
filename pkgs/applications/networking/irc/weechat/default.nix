{ stdenv, fetchurl, ncurses, openssl, aspell, gnutls
, zlib, curl , pkgconfig, libgcrypt
, cmake, makeWrapper, libobjc, libiconv
, asciidoctor # manpages
, guileSupport ? true, guile
, luaSupport ? true, lua5
, perlSupport ? true, perl
, pythonPackages
, rubySupport ? true, ruby
, tclSupport ? true, tcl
, extraBuildInputs ? [] }:

assert guileSupport -> guile != null;
assert luaSupport -> lua5 != null;
assert perlSupport -> perl != null;
assert rubySupport -> ruby != null;
assert tclSupport -> tcl != null;

let
  inherit (pythonPackages) python pycrypto pync;
in

stdenv.mkDerivation rec {
  version = "1.6";
  name = "weechat-${version}";

  src = fetchurl {
    url = "http://weechat.org/files/src/weechat-${version}.tar.bz2";
    sha256 = "0d1wcpsxx13clcf1ygcn5hsa1pjkck4xznbjbxphbdxd5whsbv3k";
  };

  outputs = [ "out" "doc" ];

  enableParallelBuilding = true;
  cmakeFlags = with stdenv.lib; [
    "-DENABLE_MAN=ON"
    "-DENABLE_DOC=ON"
  ]
    ++ optionals stdenv.isDarwin ["-DICONV_LIBRARY=${libiconv}/lib/libiconv.dylib" "-DCMAKE_FIND_FRAMEWORK=LAST"]
    ++ optional (!guileSupport) "-DENABLE_GUILE=OFF"
    ++ optional (!luaSupport)   "-DENABLE_LUA=OFF"
    ++ optional (!perlSupport)  "-DENABLE_PERL=OFF"
    ++ optional (!rubySupport)  "-DENABLE_RUBY=OFF"
    ++ optional (!tclSupport)   "-DENABLE_TCL=OFF"
    ;

  buildInputs = with stdenv.lib; [
      ncurses python openssl aspell gnutls zlib curl pkgconfig
      libgcrypt pycrypto makeWrapper
      cmake
      asciidoctor
      ]
    ++ optionals stdenv.isDarwin [ pync libobjc ]
    ++ optional  guileSupport    guile
    ++ optional  luaSupport      lua5
    ++ optional  perlSupport     perl
    ++ optional  rubySupport     ruby
    ++ optional  tclSupport      tcl
    ++ extraBuildInputs;

  NIX_CFLAGS_COMPILE = "-I${python}/include/${python.libPrefix}"
    # Fix '_res_9_init: undefined symbol' error
    + (stdenv.lib.optionalString stdenv.isDarwin "-DBIND_8_COMPAT=1");

  postInstall = with stdenv.lib; ''
    NIX_PYTHONPATH="$out/lib/${python.libPrefix}/site-packages"
    wrapProgram "$out/bin/weechat" \
      ${optionalString perlSupport "--prefix PATH : ${perl}/bin"} \
      --prefix PATH : ${pythonPackages.python}/bin \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix PYTHONPATH : "$NIX_PYTHONPATH"
  '';

  meta = {
    homepage = http://www.weechat.org/;
    description = "A fast, light and extensible chat client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ lovek323 garbas the-kenny ];
    platforms = stdenv.lib.platforms.unix;
  };
}
