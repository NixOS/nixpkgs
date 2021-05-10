{ lib
, stdenv
, fetchurl
, guile
, guile-commonmark
, guile-reader
, makeWrapper
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "haunt";
  version = "0.2.4";

  src = fetchurl {
    url = "https://files.dthompson.us/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-zOkICg7KmJJhPWPtJRT3C9sYB1Oig1xLtgPNGe0n3xQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    guile
    guile-commonmark
    guile-reader
  ];

  doCheck = true;

  postInstall =
    let
      guileVersion = lib.versions.majorMinor guile.version;
    in
    ''
      wrapProgram $out/bin/haunt \
        --prefix GUILE_LOAD_PATH : "$out/share/guile/site/${guileVersion}:$GUILE_LOAD_PATH" \
        --prefix GUILE_LOAD_COMPILED_PATH : "$out/lib/guile/${guileVersion}/site-ccache:$GUILE_LOAD_COMPILED_PATH"
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/haunt --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://dthompson.us/projects/haunt.html";
    description = "Guile-based static site generator";
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres AluisioASG ];
    platforms = guile.meta.platforms;
  };
}
