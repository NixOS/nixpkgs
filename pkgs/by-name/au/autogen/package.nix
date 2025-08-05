{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  which,
  pkg-config,
  perl,
  guile_2_2,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "autogen";
  version = "5.18.16";

  src = fetchurl {
    url = "mirror://gnu/autogen/rel${version}/autogen-${version}.tar.xz";
    sha256 = "16mlbdys8q4ckxlvxyhwkdnh1ay9f6g0cyp1kylkpalgnik398gq";
  };

  patches =
    let
      dp =
        {
          ver ? "1%255.18.16-5",
          name,
          sha256,
        }:
        fetchurl {
          url =
            "https://salsa.debian.org/debian/autogen/-/raw/debian/${ver}"
            + "/debian/patches/${name}?inline=false";
          inherit name sha256;
        };
    in
    [
      (dp {
        name = "20_no_Werror.diff";
        sha256 = "08z4s2ifiqyaacjpd9pzr59w8m4j3548kkaq1bwvp2gjn29m680x";
      })
      (dp {
        name = "30_ag_macros.m4_syntax_error.diff";
        sha256 = "1z8vmbwbkz3505wd33i2xx91mlf8rwsa7klndq37nw821skxwyh3";
      })
      (dp {
        name = "31_allow_overriding_AGexe_for_crossbuild.diff";
        sha256 = "0h9wkc9bqb509knh8mymi43hg6n6sxg2lixvjlchcx7z0j7p8xkf";
      })
      (dp {
        name = "40_suse_01-autogen-catch-race-error.patch";
        sha256 = "1cfkym2zds1f85md1m74snxzqmzlj7wd5jivgmyl342856848xav";
      })
      (dp {
        name = "40_suse_03-gcc9-fix-wrestrict.patch";
        sha256 = "1ifdwi6gf96jc78jw7q4bfi5fgdldlf2nl55y20h6xb78kv0pznd";
      })
      (dp {
        name = "40_suse_05-sprintf-overflow.patch";
        sha256 = "136m62k68w1h5k7iapynvbyipidw35js6pq21lsc6rpxvgp0n469";
      })
      (dp {
        name = "40_suse_06-autogen-avoid-GCC-code-analysis-bug.patch";
        sha256 = "1d65zygzw2rpa00s0jy2y1bg29vkbhnjwlb5pv22rfv87zbk6z9q";
      })
      # Next upstream release will contain guile-3 support. We apply non-invasive
      # patch meanwhile.
      (fetchpatch {
        name = "guile-3.patch";
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-devel/autogen/files/autogen-5.18.16-guile-3.patch?id=43bcc61c56a5a7de0eaf806efec7d8c0e4c01ae7";
        sha256 = "18d7y1f6164dm1wlh7rzbacfygiwrmbc35a7qqsbdawpkhydm5lr";
      })
      (fetchpatch {
        name = "lfs64.patch";
        url = "https://cygwin.com/cgit/cygwin-packages/autogen/plain/5.16.2-cygwin17.patch?id=6f39882873b3d1290ba3739e0557a84bfe05ba60";
        stripLen = 1;
        hash = "sha256-6dk2imqForUHKhI82CTronWaS3KUWW/EKfA/JZZcRe0=";
      })
    ];

  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
    "man"
    "info"
  ];

  nativeBuildInputs = [
    which
    pkg-config
    perl
    autoreconfHook # patches applied
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # autogen needs a build autogen when cross-compiling
    buildPackages.buildPackages.autogen
    buildPackages.texinfo
  ];
  buildInputs = [
    guile_2_2
    libxml2
  ];

  preConfigure = ''
    export MAN_PAGE_DATE=$(date '+%Y-%m-%d' -d "@$SOURCE_DATE_EPOCH")
  '';

  configureFlags = [
    "--with-libxml2=${libxml2.dev}"
    "--with-libxml2-cflags=-I${libxml2.dev}/include/libxml2"
    # Make sure to use a static value for the timeout. If we do not set a value
    # here autogen will select one based on the execution time of the configure
    # phase which is not really reproducible.
    #
    # If you are curious about the number 78, it has been cargo-culted from
    # Debian: https://salsa.debian.org/debian/autogen/-/blob/master/debian/rules#L21
    "--enable-timeout=78"
    "CFLAGS=-D_FILE_OFFSET_BITS=64"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # the configure check for regcomp wants to run a host program
    "libopts_cv_with_libregex=yes"
    #"MAKEINFO=${buildPackages.texinfo}/bin/makeinfo"
  ]
  # See: https://sourceforge.net/p/autogen/bugs/187/
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "ac_cv_func_utimensat=no" ];

  #doCheck = true; # not reliable

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/autoopts-config $dev/bin

    for f in $lib/lib/autogen/tpl-config.tlib $out/share/autogen/tpl-config.tlib; do
      sed -e "s|$dev/include|/no-such-autogen-include-path|" -i $f
      sed -e "s|$bin/bin|/no-such-autogen-bin-path|" -i $f
      sed -e "s|$lib/lib|/no-such-autogen-lib-path|" -i $f
    done

  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # remove build directory (/build/**, or /tmp/nix-build-**) from RPATHs
    for f in "$bin"/bin/*; do
      local nrp="$(patchelf --print-rpath "$f" | sed -E 's@(:|^)'$NIX_BUILD_TOP'[^:]*:@\1@g')"
      patchelf --set-rpath "$nrp" "$f"
    done
  '';

  meta = with lib; {
    description = "Automated text and program generation tool";
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    homepage = "https://www.gnu.org/software/autogen/";
    platforms = platforms.all;
    maintainers = [ ];
  };
}
