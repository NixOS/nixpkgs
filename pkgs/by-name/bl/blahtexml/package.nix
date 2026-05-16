{
  fetchFromGitHub,
  lib,
  stdenv,
  libiconv,
  texliveFull,
  xercesc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blahtexml";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "gvanas";
    repo = "blahtexml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DL5DyfARHHbwWBVHSa/VwHzNaAx/v7EDdnw1GLOk+y0=";
  };

  postPatch =
    lib.optionalString stdenv.cc.isClang ''
      substituteInPlace makefile \
        --replace "\$(CXX)" "\$(CXX) -std=c++98"
    ''
    +
    # fix the doc build on TeX Live 2023
    ''
      substituteInPlace Documentation/manual.tex \
        --replace '\usepackage[utf8x]{inputenc}' '\usepackage[utf8]{inputenc}'
    '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [ texliveFull ]; # scheme-full needed for ucs package
  buildInputs = [ xercesc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  buildFlags = [
    "doc"
  ]
  ++ (
    if stdenv.hostPlatform.isDarwin then
      [
        "blahtex-mac"
        "blahtexml-mac"
      ]
    else
      [
        "blahtex-linux"
        "blahtexml-linux"
      ]
  );

  installPhase = ''
    install -D -t "$out/bin" blahtex blahtexml
    install -m644 -D -t "$doc/share/doc/blahtexml" Documentation/manual.pdf
  '';

  meta = {
    homepage = "https://gva.noekeon.org/blahtexml/";
    description = "TeX to MathML converter";
    longDescription = ''
      Blahtex is a program written in C++, which converts an equation given in
      a syntax close to TeX into MathML. It is designed by David Harvey and is
      aimed at supporting equations in MediaWiki.

      Blahtexml is a simple extension of blahtex, written by Gilles Van Assche.
      In addition to the functionality of blahtex, blahtexml has XML processing
      in mind and is able to process a whole XML document into another XML
      document. Instead of converting only one formula at a time, blahtexml can
      convert all the formulas of the given XML file into MathML.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.xworld21 ];
    platforms = lib.platforms.all;
  };
})
