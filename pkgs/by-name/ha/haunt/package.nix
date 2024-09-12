{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, callPackage
, guile
, guile-commonmark
, guile-reader
, makeWrapper
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "haunt";
  version = "0.2.6";

  src = fetchurl {
    url = "https://files.dthompson.us/haunt/haunt-${finalAttrs.version}.tar.gz";
    hash = "sha256-vPKLQ9hDJdimEAXwIBGgRRlefM8/77xFQoI+0J/lkNs=";
  };

  # Symbol not found: inotify_init
  patches = [
    (fetchpatch {
      url = "https://git.dthompson.us/haunt.git/patch/?id=ab0b722b0719e3370a21359e4d511af9c4f14e60";
      hash = "sha256-TPNJKGlbDkV9RpdN274qMLoN3HlwfH/yHpxlpqOPw58=";
    })
    (fetchpatch {
      url = "https://git.dthompson.us/haunt.git/patch/?id=7d0b71f6a3f0e714da5a5c43e52408e27f44c383";
      hash = "sha256-CW/h8CqsALKDuKRoN1bd/WEtFTvFj0VxtgmpatyrLm8=";
    })
    (fetchpatch {
      url = "https://git.dthompson.us/haunt.git/patch/?id=1a91f3d0568fc095d8b0875c6553ef15b76efa4c";
      hash = "sha256-+3wUlTuzbyGibAsCiYWKvzPqUrFs7VwdhnADjnPuWIY=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    guile
    guile-commonmark
    guile-reader
  ];

  # Test suite is non-determinisitic in later versions
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/haunt \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  passthru = {
    tests = {
      expectVersion = callPackage ./tests/001-test-version.nix { };
    };
  };

  meta = {
    homepage = "https://dthompson.us/projects/haunt.html";
    description = "Guile-based static site generator";
    mainProgram = "haunt";
    longDescription = ''
      Haunt is a simple, functional, hackable static site generator that gives
      authors the ability to treat websites as Scheme programs.

      By giving authors the full expressive power of Scheme, they are able to
      control every aspect of the site generation process. Haunt provides a
      simple, functional build system that can be easily extended for this
      purpose.

      Haunt has no opinion about what markup language authors should use to
      write posts, though it comes with support for the popular Markdown
      format. Likewise, Haunt has no opinion about how authors structure their
      sites. Though it comes with support for building simple blogs or Atom
      feeds, authors should feel empowered to tweak, replace, or create builders
      to do things that aren't provided out-of-the-box.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (guile.meta) platforms;
  };
})
