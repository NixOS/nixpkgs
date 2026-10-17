{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  bzip2,
  libxml2,
  minizip,
  pkg-config,
  readline,
  uriparser,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collada-dom";
  version = "2.5.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "collada-dom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-51CwWqxQP+rTQgsHfnI/krJcpI9Lb6PXe/td/ztoiRY=";
  };

  postInstall = ''
    ln -s $out/include/*/* $out/include
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    bzip2
    libxml2
    minizip
    readline
    uriparser
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "OPT_COMPILE_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

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
