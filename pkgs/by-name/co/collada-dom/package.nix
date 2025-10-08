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
  version = "2.5.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "collada-dom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DYdqrwRIrVq0BQqZB0vtZzADteJGVaJtFC5kC/cD250=";
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

  cmakeFlags = [
    # See https://github.com/NixOS/nixpkgs/issues/445447
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
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
    ];
    platforms = lib.platforms.all;

    # Fails to build.
    badPlatforms = lib.platforms.darwin;
  };
})
