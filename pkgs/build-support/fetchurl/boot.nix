let mirrors = import ./mirrors.nix; in

{ system
, stdenv
, fetchurl }:

{ url ? builtins.head urls
, urls ? []
, sha256 ? ""
, hash ? ""
, name ? baseNameOf (toString url)
, postFetch ? null
}@args:

# assert at most one hash is set
assert hash != "" -> sha256 == "";
assert sha256 != "" -> hash == "";

if postFetch==null
then import ./nix-fetchurl.nix {
  inherit system hash sha256 name;

  url =
    # Handle mirror:// URIs. Since <nix/fetchurl.nix> currently
    # supports only one URI, use the first listed mirror.
    let m = builtins.match "mirror://([a-z]+)/(.*)" url; in
    if m == null then url
    else builtins.head (mirrors.${builtins.elemAt m 0}) + (builtins.elemAt m 1);
}
else stdenv.mkDerivation {
  inherit name;
  srcs = [ ];
  unpackPhase = ''
    runHook preUnpack
    cp '${fetchurl (args // { postFetch = null; hash = ""; sha256 = ""; })}' $out
    chmod +w $out
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
  '' + postFetch + ''
    runHook postInstall
  '';
  outputHash = if hash != "" then hash else sha256;
  outputHashAlgo = if hash != "" then "" else "sha256";
  outputHashMode = "flat";
}
