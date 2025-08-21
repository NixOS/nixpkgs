{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  libxml2,
  minizip,
  readline,
}:

stdenv.mkDerivation {
  pname = "collada-dom";
  version = "2.5.0-unstable-2020-01-03";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rdiankov";
    repo = "collada-dom";
    rev = "c1e20b7d6ff806237030fe82f126cb86d661f063";
    hash = "sha256-A1ne/D6S0shwCzb9spd1MoSt/238HWA8dvgd+DC9cXc=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/rdiankov/collada-dom/commit/65222c3c4f800b624e1d547ab7f1eb28e3d6ee59.patch";
      hash = "sha256-8aSc21IaBdvhX8QKhBt8mzy/WfinRMI22ZlH9M0QJKg=";
    })
  ];

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
    homepage = "https://github.com/rdiankov/collada-dom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sigmasquadron
      marius851000
    ];
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin;
  };
}
