{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  texinfo,
  guile,
  guile-commonmark,
  guile-reader,
  makeBinaryWrapper,
  pkg-config,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "haunt";
  version = "0.3.0";

  src = fetchgit {
    url = "https://git.dthompson.us/haunt.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i6MI0eaRiA/JNgkIBJGLAsqMnyJz47aavyD6kOL7sqU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeBinaryWrapper
    pkg-config
    texinfo
  ];

  buildInputs = [
    guile
    guile-commonmark
    guile-reader
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall = ''
    wrapProgram $out/bin/haunt \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
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
    maintainers = with lib.maintainers; [ normalcea ];
    inherit (guile.meta) platforms;
  };
})
