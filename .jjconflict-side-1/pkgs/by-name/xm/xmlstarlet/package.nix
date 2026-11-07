{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libxml2,
  libxslt,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xmlstarlet";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "xmlstarlet";
    repo = "xmlstarlet";
    tag = "${finalAttrs.version}";
    hash = "sha256-dnuDDr14ACB16r1/N9g71RxPaVjHbikjDef3OLqzMZQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libxml2
    libxslt
  ];

  # installing the docs requires internet
  configureFlags = [ "--disable-install-docs" ];

  preConfigure = ''
    export LIBXSLT_PREFIX=${libxslt.dev}
    export LIBXML_PREFIX=${libxml2.dev}
    export LIBXSLT_LIBS=$($PKG_CONFIG --libs libxslt libexslt)
    export LIBXML_LIBS=$($PKG_CONFIG --libs libxml-2.0)
  '';

  postInstall = ''
    ln -s xml $out/bin/xmlstarlet
  '';

  meta = {
    description = "Command line tool for manipulating and querying XML data";
    homepage = "https://xmlstarlet.github.io/";
    license = lib.licenses.mit;
    mainProgram = "xmlstarlet";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.evanwporter ];
  };
})
