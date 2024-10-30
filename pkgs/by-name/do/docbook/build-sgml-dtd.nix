{
  version,
  hash,
}:
{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docbook";
  inherit version;

  srcs = [
    (fetchurl {
      url =
        with lib.strings;
        concatStrings [
          "https://www.oasis-open.org/docbook/sgml/"
          version
          "/docbk"
          (concatStrings (splitString "." version))
          ".zip"
        ];
      inherit hash;
    })
    (fetchurl {
      url = "https://www.oasis-open.org/cover/ISOEnts.zip";
      hash = "sha256-3OQ1mjmW7S/TOtXqoRqbz8JLWwaZLiQpUTKwbbGambI=";
    })
  ];

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  unpackPhase = ''
    runHook preUnpack

    mkdir dumpdir

    for s in $srcs; do
        unzip $s -d dumpdir
    done

    runHook postUnpack
  '';

  postPatch = ''
    sed -e "s/iso-/ISO/" -e "s/.gml//" -i dumpdir/docbook.cat
  '';

  installPhase = ''
    runHook preInstall

    dst=$out/sgml/dtd/docbook-${version}
    mkdir -p $dst

    cp -pr -t $dst dumpdir/*

    runHook postInstall
  '';

  meta = {
    description = "General purpose SGML schema";
    longDescription = ''
      DocBook is a general purpose SGML schema particularly well suited to books
      and papers about computer hardware and software (though it is by no means
      limited to these applications).
    '';
    homepage = "https://docbook.org/";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = lib.platforms.all;
  };
})
