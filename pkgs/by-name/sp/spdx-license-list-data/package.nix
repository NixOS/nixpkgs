{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:
let
  # List of file formats to package.
  _types = [
    "html"
    "json"
    "jsonld"
    "rdfa"
    "rdfnt"
    "rdfturtle"
    "rdfxml"
    "template"
    "text"
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "spdx-license-list-data";
  version = "3.28.0";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FbeeEBAg9ih6DkAsXdU6ruZwkC7A2u2zYBvblpl54q0=";
  };

  outputs = [ "out" ] ++ _types;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -pv $out
    for t in ${lib.concatStringsSep " " _types}
    do
      _outpath=''${!t}
      mkdir -pv $_outpath
      cp -ar $t $_outpath && echo "$t format installed"
    done

    runHook postInstall
  '';

  dontFixup = true;

  meta = {
    description = "Various data formats for the SPDX License List";
    homepage = "https://github.com/spdx/license-list-data";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [
      oxzi
    ];
    platforms = lib.platforms.all;
  };
})
