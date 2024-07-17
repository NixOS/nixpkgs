{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "procmail";
  version = "3.24";

  src = fetchurl {
    url = "https://github.com/BuGlessRB/procmail/archive/refs/tags/v${version}.tar.gz";
    sha256 = "UU6kMzOXg+ld+TIeeUdx5Ih7mCOsVf2yRpcCz2m9OYk=";
  };

  patches = [
    # Fix clang-16 and gcc-14 build failures:
    #   https://github.com/BuGlessRB/procmail/pull/7
    (fetchpatch {
      name = "clang-16.patch";
      url = "https://github.com/BuGlessRB/procmail/commit/8cfd570fd14c8fb9983859767ab1851bfd064b64.patch";
      hash = "sha256-CaQeDKwF0hNOrxioBj7EzkCdJdsq44KwkfA9s8xK88g=";
    })
  ];

  # getline is defined differently in glibc now. So rename it.
  # Without the .PHONY target "make install" won't install anything on Darwin.
  postPatch =
    ''
      sed -i Makefile \
        -e "s%^RM.*$%#%" \
        -e "s%^BASENAME.*%\BASENAME=$out%" \
        -e "s%^LIBS=.*%LIBS=-lm%"
      sed -e "s%getline%thisgetline%g" -i src/*.c src/*.h
      sed -e "3i\
      .PHONY: install
      " -i Makefile
    ''
    + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      substituteInPlace src/Makefile.0 \
        --replace-fail '@./_autotst' '@${stdenv.hostPlatform.emulator buildPackages} ./_autotst'
      sed -e '3i\
      _autotst() { ${stdenv.hostPlatform.emulator buildPackages} ./_autotst "$@"; } \
      _locktst() { ${stdenv.hostPlatform.emulator buildPackages} ./_locktst "$@"; } \
      ' -i src/autoconf
    '';

  # default target is binaries + manpages; manpages don't cross compile without more work.
  makeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [ "bins" ];
  installTargets = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "install.bin"
  ];

  meta = with lib; {
    description = "Mail processing and filtering utility";
    homepage = "https://github.com/BuGlessRB/procmail/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
