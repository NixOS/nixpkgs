{
  lib,
  stdenv,
  fetchurl,
  libiconv,
  libpng,
  ncurses,
  pcre,
  readline,
  zlib,
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "slang";
  version = "2.3.3";

  src = fetchurl {
    url = "https://www.jedsoft.org/releases/slang/${pname}-${version}.tar.bz2";
    sha256 = "sha256-+RRQVK4TGXPGEgjqgkhtXdEOPFza0jt8SgYXdDyPWhg=";
  };

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  # Fix some wrong hardcoded paths
  preConfigure = ''
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" configure
    sed -i -e "s|/usr/lib/terminfo|${ncurses.out}/lib/terminfo|" src/sltermin.c
    sed -i -e "s|/bin/ln|ln|" src/Makefile.in
    sed -i -e "s|-ltermcap|-lncurses|" ./configure
  '';

  configureFlags = [
    "--with-pcre=${pcre.dev}"
    "--with-png=${libpng.dev}"
    "--with-readline=${readline.dev}"
    "--with-z=${zlib.dev}"
  ];

  buildInputs = [
    libpng
    pcre
    readline
    zlib
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ libiconv ];

  propagatedBuildInputs = [ ncurses ];

  buildFlags = lib.optional stdenv.hostPlatform.isStatic "static";
  installTargets = lib.optional stdenv.hostPlatform.isStatic "install-static";

  preBuild = ''
    makeFlagsArray+=(AR_CR="${stdenv.cc.targetPrefix}ar cr")
  '';

  enableParallelBuilding = true;

  postInstall = ''
    find "$out"/lib/ -name '*.so' -exec chmod +x "{}" \;
    sed '/^Libs:/s/$/ -lncurses/' -i "$dev"/lib/pkgconfig/slang.pc
  '';

  passthru = {
    updateScript = writeScript "update-slang" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of 'Version 2.3.3</td>'
      new_version="$(curl -s https://www.jedsoft.org/slang/ |
          pcregrep -o1 'Version ([0-9.]+)</td>')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = with lib; {
    description = "Small, embeddable multi-platform programming library";
    longDescription = ''
      S-Lang is an interpreted language that was designed from the start to be
      easily embedded into a program to provide it with a powerful extension
      language. Examples of programs that use S-Lang as an extension language
      include the jed text editor and the slrn newsreader. Although S-Lang does
      not exist as a separate application, it is distributed with a quite
      capable program called slsh ("slang-shell") that embeds the interpreter
      and allows one to execute S-Lang scripts, or simply experiment with S-Lang
      at an interactive prompt. Many of the the examples in this document are
      presented in the context of one of the above applications.

      S-Lang is also a programmer's library that permits a programmer to develop
      sophisticated platform-independent software. In addition to providing the
      S-Lang interpreter, the library provides facilities for screen management,
      keymaps, low-level terminal I/O, etc. However, this document is concerned
      only with the extension language and does not address these other features
      of the S-Lang library. For information about the other components of the
      library, the reader is referred to the S-Lang Library C Programmer's
      Guide.
    '';
    homepage = "http://www.jedsoft.org/slang/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    mainProgram = "slsh";
    platforms = platforms.unix;
  };
}
