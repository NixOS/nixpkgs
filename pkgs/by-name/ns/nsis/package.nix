{
  lib,
  stdenv,
  symlinkJoin,
  fetchurl,
  fetchzip,
  makeWrapper,
  runCommand,
  scons,
  zlib,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nsis";
  version = "3.12";

  src = fetchurl {
    url = "mirror://sourceforge/project/nsis/NSIS%203/${finalAttrs.version}/nsis-${finalAttrs.version}-src.tar.bz2";
    sha256 = "11miw8jbhqcn5wmndcjdjfs0r7jm08x5cfvxyj64xkx29a77mvgk";
  };
  srcWinDistributable = fetchzip {
    url = "mirror://sourceforge/project/nsis/NSIS%203/${finalAttrs.version}/nsis-${finalAttrs.version}.zip";
    sha256 = "0rp9bycykjgx2aq656sdba1h4v14nfyiic2lgp1xm93l2czx9k9q";
  };

  postUnpack = ''
    mkdir -p $out/share/nsis
    cp -avr ${finalAttrs.srcWinDistributable}/{Contrib,Include,Plugins,Stubs} \
      $out/share/nsis
    chmod -R u+w $out/share/nsis
  '';

  nativeBuildInputs = [ scons ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];
  buildInputs = [ zlib ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  env = {
    CPPPATH = symlinkJoin {
      name = "nsis-includes";
      paths = [ zlib.dev ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];
    };

    LIBPATH = symlinkJoin {
      name = "nsis-libs";
      paths = [ zlib ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];
    };
  };

  sconsFlags = [
    "SKIPSTUBS=all"
    "SKIPPLUGINS=all"
    "SKIPUTILS=all"
    "SKIPMISC=all"
    "NSIS_CONFIG_CONST_DATA=no"
    "VERSION=${finalAttrs.version}"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "APPEND_LINKFLAGS=-liconv";

  preBuild = ''
    sconsFlagsArray+=(
      "PATH=$PATH"
      "CC=$CC"
      "CXX=$CXX"
      "APPEND_CPPPATH=$CPPPATH/include"
      "APPEND_LIBPATH=$LIBPATH/lib"
    )
  '';

  prefixKey = "PREFIX=";
  installTargets = [ "install-compiler" ];

  # NSIS can crash when compiling Unicode installers under non-UTF-8 locales on macOS
  # see https://sourceforge.net/p/nsis/bugs/1165/ for more info
  # code adapted from the makensis formulae in Homebrew
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    wrapProgram $out/bin/makensis \
      --run '
        case "''${LC_ALL:-}" in
          *UTF-8*|*utf8*) ;;
          "")
            case "''${LC_CTYPE:-} ''${LANG:-}" in
              *UTF-8*|*utf8*) ;;
              *) export LC_ALL=en_US.UTF-8 ;;
            esac
            ;;
          *) export LC_ALL=en_US.UTF-8 ;;
        esac
      '
  '';

  passthru.tests = {
    compile-bigtest =
      runCommand "nsis-compile-bigtest" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          pushd ${finalAttrs.srcWinDistributable}/Examples >/dev/null
          makensis bigtest.nsi "-XOutfile /dev/null"
          popd >/dev/null
          touch $out
        '';
  };

  meta = {
    description = "Free scriptable win32 installer/uninstaller system that doesn't suck and isn't huge";
    homepage = "https://nsis.sourceforge.io/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pombeirp ];
    mainProgram = "makensis";
  };
})
