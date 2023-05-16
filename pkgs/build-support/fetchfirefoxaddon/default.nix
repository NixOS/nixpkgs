<<<<<<< HEAD
{ stdenv
, fetchurl
, jq
, strip-nondeterminism
, unzip
, writeScript
, zip
}:

{ name
, url ? null
=======
{stdenv, unzip, jq, zip, fetchurl,writeScript,  ...}:

{
  name
, url ? null
, md5 ? ""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sha1 ? ""
, sha256 ? ""
, sha512 ? ""
, fixedExtid ? null
, hash ? ""
, src ? ""
}:

let
  extid = if fixedExtid == null then "nixos@${name}" else fixedExtid;
<<<<<<< HEAD
  source = if url == null then src else
  fetchurl {
    url = url;
    inherit sha1 sha256 sha512 hash;
=======
  source = if url == null then src else fetchurl {
    url = url;
    inherit md5 sha1 sha256 sha512 hash;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
stdenv.mkDerivation {
  inherit name;

  passthru = {
    inherit extid;
  };

  builder = writeScript "xpibuilder" ''
    source $stdenv/setup

    echo "firefox addon $name into $out"

    UUID="${extid}"
    mkdir -p "$out/$UUID"
    unzip -q ${source} -d "$out/$UUID"
    NEW_MANIFEST=$(jq '. + {"applications": { "gecko": { "id": "${extid}" }}, "browser_specific_settings":{"gecko":{"id": "${extid}"}}}' "$out/$UUID/manifest.json")
    echo "$NEW_MANIFEST" > "$out/$UUID/manifest.json"
    cd "$out/$UUID"
    zip -r -q -FS "$out/$UUID.xpi" *
<<<<<<< HEAD
    strip-nondeterminism "$out/$UUID.xpi"
    rm -r "$out/$UUID"
  '';

  nativeBuildInputs = [
    jq
    strip-nondeterminism
    unzip
    zip
  ];
=======
    rm -r "$out/$UUID"
  '';
  nativeBuildInputs = [ unzip zip jq  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
