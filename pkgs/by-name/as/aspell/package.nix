{
  lib,
  stdenv,
  fetchpatch,
  fetchzip,
  autoreconfHook,
  perl,
  ncurses,
  bash,

  # for tests
  glibc,
  testers,

  searchNixProfiles ? true,
  callPackage,
  aspellDicts,
}:
let
  # Source for u-deva.cmap and u-deva.cset: use the Marathi
  # dictionary like Debian does.
  devaMapsSource = fetchzip {
    name = "aspell-u-deva";
    url = "https://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2";
    hash = "sha256-IWYft6Q5T5i5dwPEahpjayWjPc49YL3XJi1I0RFtDO0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aspell";
  version = "0.60.8.1";

  src = fetchzip {
    url = "https://ftp.gnu.org/gnu/aspell/aspell-${finalAttrs.version}.tar.gz";
    hash = "sha256-SK79OKP5usZPfAinhDO75Yum0PdsU8v8Q0L0YAlJap8=";
  };

  patches = [
    ./clang.patch

    # fix gcc-15 / clang-19 build. can remove on next update
    (fetchpatch {
      name = "fix-gcc-15-build.patch";
      url = "https://github.com/GNUAspell/aspell/commit/ee6cbb12ff36a1e6618d7388a78dd4e0a2b44041.patch";
      hash = "sha256-rW1FcfARdtT4wX+zGd2x/1K8zRp9JZhdR/zRd8RwPZA=";
    })
  ]
  ++ lib.optional searchNixProfiles ./data-dirs-from-nix-profiles.patch;

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    perl
  ];
  buildInputs = [
    ncurses
    perl
    bash
  ];

  enableParallelBuilding = true;
  doCheck = true;

  configureFlags = [
    "--enable-pkglibdir=${placeholder "out"}/lib/aspell"
    "--enable-pkgdatadir=${placeholder "out"}/lib/aspell"
  ];

  # Include u-deva.cmap and u-deva.cset in the aspell package
  # to avoid conflict between 'mr' and 'hi' dictionaries as they
  # both include those files.
  postInstall = ''
    cp ${devaMapsSource}/u-deva.{cmap,cset} $out/lib/aspell/
  '';

  passthru = {
    withDicts =
      f:
      callPackage ./aspell-with-dicts.nix {
        aspell = finalAttrs.finalPackage;
        extraDicts = f aspellDicts;
      };

    tests = {

      withDicts = testers.testVersion {
        package = finalAttrs.finalPackage.withDicts (d: [
          d.zu
          d.uk
        ]);
      };

      uses-curses = testers.runCommand {
        name = "aspell-curses";
        buildInputs = [ glibc ];
        script = ''
          if ! ldd ${lib.getExe finalAttrs.finalPackage} | grep -q ${ncurses}
          then
            echo "Test failure: It does not look like aspell picked up the curses dependency."
            exit 1
          fi
          touch $out
        '';
      };
    };
  };

  meta = {
    description = "Spell checker for many languages";
    homepage = "http://aspell.net/";
    changelog = "http://aspell.net/man-html/ChangeLog.html";
    mainProgram = "aspell";
    license = with lib.licenses; [
      lgpl2Plus
      gpl2Plus
      bsd2
    ];
    maintainers = [ lib.maintainers.RossSmyth ];
    platforms = lib.platforms.all;
  };
})
