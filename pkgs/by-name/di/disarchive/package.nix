{ stdenv
, lib
, fetchurl
, guile
, autoreconfHook
, guile-gcrypt
, guile-lzma
, guile-quickcheck
, makeWrapper
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
  pname = "disarchive";
  version = "0.5.0";

  src = fetchurl {
    url = "https://files.ngyro.com/disarchive/disarchive-${version}.tar.gz";
    hash = "sha256-Agt7v5HTpaskXuYmMdGDRIolaqCHUpwd/CfbZCe9Ups=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    guile-gcrypt
    guile-lzma
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    guile
    zlib
  ];

  propagatedBuildInputs = [
    guile-gcrypt
    guile-lzma
  ];

  doCheck = !stdenv.isDarwin;

  nativeCheckInputs = [
    guile-quickcheck
  ];

  postInstall = ''
    wrapProgram $out/bin/disarchive \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  meta = with lib; {
    description = "Disassemble software into data and metadata";
    homepage = "https://ngyro.com/software/disarchive.html";
    license = licenses.gpl3Plus;
    mainProgram = "disarchive";
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
