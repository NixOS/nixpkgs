{ version, hash }:
{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docbook-sgml";
  inherit version;

  src = fetchurl {
    url = "https://archive.docbook.org/sgml/${finalAttrs.version}/${
      if lib.versionAtLeast finalAttrs.version "4.2" then
        "docbook-${finalAttrs.version}"
      else
        "docbk${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}"
    }.zip";
    inherit hash;
  };

  isoents = fetchurl {
    url = "https://web.archive.org/web/20250220122223/http://xml.coverpages.org/ISOEnts.zip";
    hash = "sha256-3OQ1mjmW7S/TOtXqoRqbz8JLWwaZLiQpUTKwbbGambI=";
  };

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/sgml/dtd/docbook-${finalAttrs.version}"
    unzip -d "$out/sgml/dtd/docbook-${finalAttrs.version}" "$src"
    unzip -d "$out/sgml/dtd/docbook-${finalAttrs.version}" "$isoents"

    substituteInPlace "$out/sgml/dtd/docbook-${finalAttrs.version}/docbook.cat" \
      --replace-fail "iso-" "ISO" \
      --replace-fail ".gml" ""

    runHook postInstall
  '';

  dontUnpack = true;
  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "DocBook ${finalAttrs.version} SGML Schemas";
    homepage = "https://docbook.org/";
    license = lib.licenses.docBookDtd;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.all;
  };
})
