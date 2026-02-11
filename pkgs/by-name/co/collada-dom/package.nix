{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  libxml2,
  minizip,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collada-dom";
  version = "2.5.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "collada-dom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-53Gf6OLwrflZcrWKPuNPS0k+jlj5yTzCkI/QYQFta48=";
  };

  postInstall = ''
    ln -s $out/include/*/* $out/include
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libxml2
    minizip
    readline
  ];

  meta = {
    description = "API that provides a C++ object representation of a COLLADA XML instance document";
    longDescription = "This is a fork of [rdiankov/collada-dom](https://github.com/rdiankov/collada-dom) which has been unmaintained for six years.";
    homepage = "https://github.com/Gepetto/collada-dom";
    changelog = "https://github.com/Gepetto/collada-dom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sigmasquadron
      marius851000
      nim65s
    ];
    platforms = lib.platforms.all;

    # Fails to build.
    badPlatforms = lib.platforms.darwin;
  };
})
