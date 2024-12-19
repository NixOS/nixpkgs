{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  patches ? [ ],
  pkgsBuildHost,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation {
  pname = "9base";
  version = "unstable-2019-09-11";

  src = fetchgit {
    url = "https://git.suckless.org/9base";
    rev = "63916da7bd6d73d9a405ce83fc4ca34845667cce";
    hash = "sha256-CNK7Ycmcl5vkmtA5VKwKxGZz8AoIG1JH/LTKoYmWSBI=";
  };

  patches = [
    # expects to be used with getcallerpc macro or stub patch
    # AR env var is now the location of `ar` not including the arg (`ar rc`)
    ./config-substitutions.patch
    ./dont-strip.patch
    # plan9port dropped their own getcallerpc implementations
    # in favour of using gcc/clang's macros or a stub
    # we can do this here too to extend platform support
    # https://github.com/9fans/plan9port/commit/540caa5873bcc3bc2a0e1896119f5b53a0e8e630
    # https://github.com/9fans/plan9port/commit/323e1a8fac276f008e6d5146a83cbc88edeabc87
    ./getcallerpc-use-macro-or-stub.patch
  ] ++ patches;

  # the 9yacc script needs to be executed to build other items
  preBuild = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace ./yacc/9yacc \
      --replace "../yacc/yacc" "${lib.getExe' pkgsBuildHost._9base "yacc"}"
  '';

  enableParallelBuilding = true;
  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  env.NIX_CFLAGS_COMPILE = toString (
    [
      # workaround build failure on -fno-common toolchains like upstream
      # gcc-10. Otherwise build fails as:
      #   ld: diffio.o:(.bss+0x16): multiple definition of `bflag'; diffdir.o:(.bss+0x6): first defined here
      "-fcommon"
      # hide really common warning that floods the logs:
      #   warning: #warning "_BSD_SOURCE and _SVID_SOURCE are deprecated, use _DEFAULT_SOURCE"
      "-D_DEFAULT_SOURCE"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      # error: call to undeclared function 'p9mbtowc'; ISO C99 and later do not support implicit function declarations
      "-Wno-error=implicit-function-declaration"
    ]
  );
  env.LDFLAGS = lib.optionalString enableStatic "-static";
  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];
  installFlags = [
    "PREFIX_TROFF=${placeholder "troff"}"
  ];

  outputs = [
    "out"
    "man"
    "troff"
  ];

  meta = with lib; {
    homepage = "https://tools.suckless.org/9base/";
    description = "9base is a port of various original Plan 9 tools for Unix, based on plan9port";
    longDescription = ''
      9base is a port of various original Plan 9 tools for Unix, based on plan9port.
      It also contains the Plan 9 libc, libbio, libregexp, libfmt and libutf.
      The overall SLOC is about 66kSLOC, so this userland + all libs is much smaller than, e.g. bash.
      9base can be used to run werc instead of the full blown plan9port.
    '';
    license = with licenses; [
      mit # and
      lpl-102
    ];
    maintainers = with maintainers; [ jk ];
    platforms = platforms.unix;
    # needs additional work to support aarch64-darwin
    # due to usage of _DARWIN_NO_64_BIT_INODE
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin;
  };
}
