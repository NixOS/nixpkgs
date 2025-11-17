{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "hexcurse";
  version = "1.60.0";

  src = fetchFromGitHub {
    owner = "LonnyGomes";
    repo = "hexcurse";
    rev = "v${version}";
    sha256 = "17ckkxfzbqvvfdnh10if4aqdcq98q3vl6dn1v6f4lhr4ifnyjdlk";
  };
  buildInputs = [ ncurses ];
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=stringop-overflow"
    "-Wno-error=stringop-truncation"
  ];
  patches = [
    # gcc7 compat
    (fetchpatch {
      url = "https://github.com/LonnyGomes/hexcurse/commit/d808cb7067d1df067f8b707fabbfaf9f8931484c.patch";
      sha256 = "0h8345blmc401c6bivf0imn4cwii67264yrzxg821r46wrnfvyi2";
    })
    # gcc7 compat
    (fetchpatch {
      url = "https://github.com/LonnyGomes/hexcurse/commit/716b5d58ac859cc240b8ccb9cbd79ace3e0593c1.patch";
      sha256 = "0v6gbp6pjpmnzswlf6d97aywiy015g3kcmfrrkspsbb7lh1y3nix";
    })

    # Fix pending upstream inclusion for gcc10 -fno-common compatibility:
    #  https://github.com/LonnyGomes/hexcurse/pull/28
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/LonnyGomes/hexcurse/commit/9cf7c9dcd012656df949d06f2986b57db3a72bdc.patch";
      sha256 = "1awsyxys4pd3gkkgyckgjg3njgqy07223kcmnpfdkidh2xb0s360";
    })

    # Fix pending upstream inclusion for ncurses-6.3 support:
    #  https://github.com/LonnyGomes/hexcurse/pull/40
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/LonnyGomes/hexcurse/commit/cb70d4a93a46102f488f471fad31a7cfc9fec025.patch";
      sha256 = "19674zhhp7gc097kl4bxvi0gblq6jzjy8cw8961svbq5y3hv1v5y";
    })
  ];

  meta = with lib; {
    description = "ncurses-based console hexeditor written in C";
    homepage = "https://github.com/LonnyGomes/hexcurse";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "hexcurse";
  };
}
