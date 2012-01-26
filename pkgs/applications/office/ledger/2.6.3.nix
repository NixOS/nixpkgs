# Patchelf fails to hard-code the library paths to ledger's
# libamounts.so and libledger-2.6.3 shared objects:
#
# $ ldd ~/.nix-profile/bin/ledger
#         linux-vdso.so.1 =>  (0x00007fff513ff000)
#         libamounts.so.0 => not found
#         libledger-2.6.3.so => not found
#         libstdc++.so.6 => /nix/store/3r8kfi33y3lbrsvlx8vzwm74h8178y35-gcc-4.5.1/lib/../lib64/libstdc++.so.6 (0x00007f1f0feee000)
#         libpcre.so.0 => /nix/store/kfhy189arpj3wrfzpgw8p9ac4g4hfgca-pcre-8.10/lib/libpcre.so.0 (0x00007f1f0fcd3000)
#         libgmp.so.3 => /nix/store/ji6py9m9w2ray1bmpkmgig9llj1i2ggf-gmp-4.3.2/lib/libgmp.so.3 (0x00007f1f0fa7f000)
#         libm.so.6 => /nix/store/vxycd107wjbhcj720hzkw2px7s7kr724-glibc-2.12.2/lib/libm.so.6 (0x00007f1f0f7fd000)
#         libgcc_s.so.1 => /nix/store/3r8kfi33y3lbrsvlx8vzwm74h8178y35-gcc-4.5.1/lib/../lib64/libgcc_s.so.1 (0x00007f1f0f5e8000)
#         libc.so.6 => /nix/store/vxycd107wjbhcj720hzkw2px7s7kr724-glibc-2.12.2/lib/libc.so.6 (0x00007f1f0f27d000)
#         /nix/store/vxycd107wjbhcj720hzkw2px7s7kr724-glibc-2.12.2/lib/ld-linux-x86-64.so.2 (0x00007f1f101ef000)
#
# Fortunately, libtools builds the program with proper paths hard-coded
# alread, so we don't need patchelf. Phew!

{stdenv, fetchurl, emacs, gmp, pcre, expat}:

let
  name = "ledger-2.6.3";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://github.com/downloads/jwiegley/ledger/${name}.tar.gz";
    sha256 = "05zpnypcwgck7lwk00pbdlcwa347xsqifxh4zsbbn01m98bx1v5k";
  };

  buildInputs = [ emacs gmp pcre expat ];

  configureFlags = "CPPFLAGS=-DNDEBUG CFLAGS=-O3 CXXFLAGS=-O3";
  dontPatchELF = true;
  doCheck = true;

  meta = {
    homepage = "http://ledger-cli.org/";
    description = "A double-entry accounting system with a command-line reporting interface";
    license = "BSD";

    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
