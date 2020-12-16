{stdenv, lib, coreutils, unzip, jq, zip, fetchurl,writeScript,  ...}:

{
  name
, url
, md5 ? ""
, sha1 ? ""
, sha256 ? ""
, sha512 ? ""
, fixedExtid ? null
, hash ? ""
}:

stdenv.mkDerivation rec {

  inherit name;
  extid = if fixedExtid == null then "nixos@${name}" else fixedExtid;
  passthru = {
    exitd=extid;
  };

  builder = writeScript "xpibuilder" ''
    source $stdenv/setup

    header "firefox addon $name into $out"

    UUID="${extid}"
    mkdir -p "$out/$UUID"
    unzip -q ${src} -d "$out/$UUID"
    NEW_MANIFEST=$(jq '. + {"applications": { "gecko": { "id": "${extid}" }}, "browser_specific_settings":{"gecko":{"id": "${extid}"}}}' "$out/$UUID/manifest.json")
    echo "$NEW_MANIFEST" > "$out/$UUID/manifest.json"
    cd "$out/$UUID"
    zip -r -q -FS "$out/$UUID.xpi" *
    rm -r "$out/$UUID"
  '';
  src = fetchurl {
    url = url;
    inherit md5 sha1 sha256 sha512 hash;
  };
  nativeBuildInputs = [ coreutils unzip zip jq  ];
}
