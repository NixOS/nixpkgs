{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  callPackage,
  guile,
  guile-commonmark,
  guile-reader,
  makeWrapper,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "haunt";
  version = "0.3.0";

  src = fetchurl {
    url = "https://files.dthompson.us/haunt/haunt-${finalAttrs.version}.tar.gz";
    hash = "sha256-mLq+0GvlSgZsPryUQQqR63zEg2fpTVKBMdO6JxSZmSs=";
  };

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
