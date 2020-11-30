{stdenv, lib, coreutils, unzip, jq, zip, fetchurl,writeScript,  ...}:
let

in
  { name,
  url,
  sha256,
}:

stdenv.mkDerivation rec {

  inherit name;
  extid = "${sha256}@${name}";
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
    sha256 = sha256;
  };
  nativeBuildInputs = [ coreutils unzip zip jq  ];
}

