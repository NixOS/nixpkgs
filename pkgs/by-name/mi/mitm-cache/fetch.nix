{
  lib,
  fetchurl,
  runCommand,
  writeText,
}:

{
  name ? "deps",
  data,
  dontFixup ? true,
  # Overrides: attrset keyed by "groupId:artifactId:version" ->
  #   { "artifactId-version.jar" = originalDrv: replacementDrv; }
  # Allows substituting fetched Maven artifacts with local nixpkgs derivations.
  # Build this with gradle.mkGradleLocalOverrides or gradle.mkVersionChainUpgrade.
  overrides ? { },
  ...
}@attrs:

let
  # Known Maven repository URL prefixes for GAV coordinate extraction.
  mavenRepoPrefixes = [
    "https://repo.maven.apache.org/maven2/"
    "https://repo1.maven.org/maven2/"
    "https://plugins.gradle.org/m2/"
    "https://jcenter.bintray.com/"
    "https://dl.google.com/dl/android/maven2/"
    "https://maven.google.com/"
    "https://oss.sonatype.org/content/repositories/releases/"
    "https://s01.oss.sonatype.org/content/repositories/releases/"
    "https://jitpack.io/"
    "https://repo.clojars.org/"
  ];

  # Extract "groupId:artifactId:version" from a Maven artifact URL, or null if
  # the URL is not from a recognized Maven repository.
  mavenUrlToGav =
    url:
    let
      prefix = lib.findFirst (p: lib.hasPrefix p url) null mavenRepoPrefixes;
    in
    if prefix == null then
      null
    else
      let
        rel = lib.removePrefix prefix url;
        parts = lib.splitString "/" rel;
        n = builtins.length parts;
      in
      if n < 4 then
        null
      else
        let
          filename = builtins.elemAt parts (n - 1);
          version = builtins.elemAt parts (n - 2);
          artifactId = builtins.elemAt parts (n - 3);
          groupParts = lib.take (n - 3) parts;
          groupId = builtins.concatStringsSep "." groupParts;
        in
        if groupId == "" || artifactId == "" || version == "" then
          null
        else if !lib.hasPrefix "${artifactId}-${version}" filename then
          null
        else
          "${groupId}:${artifactId}:${version}";

  hasOverrides = overrides != { };

  # Return the override for this URL if one exists, otherwise return the
  # original binary unchanged. Only applied to `hash` entries (downloaded files).
  doOverride =
    binary: url:
    if !hasOverrides then
      binary
    else
      let
        gav = mavenUrlToGav url;
        # Attribute lookup requires a string key; guard against non-Maven URLs.
        gavOverrides = if gav != null then overrides.${gav} or { } else { };
        filename = baseNameOf url;
      in
      if gavOverrides ? ${filename} then gavOverrides.${filename} binary else binary;

  data' = removeAttrs (if builtins.isPath data then lib.importJSON data else data) [
    "!version"
  ];

  urlToPath =
    url:
    if lib.hasPrefix "https://" url then
      (
        let
          url' = lib.drop 2 (lib.splitString "/" url);
        in
        "https/${builtins.concatStringsSep "/" url'}"
      )
    else
      builtins.replaceStrings [ "://" ] [ "/" ] url;

  code = ''
    mkdir -p "$out"
    cd "$out"
  ''
  + builtins.concatStringsSep "" (
    lib.mapAttrsToList (
      url: info:
      let
        key = builtins.head (builtins.attrNames info);
        val = info.${key};
        path = urlToPath url;
        name = baseNameOf path;
        isHash = key == "hash";
        source0 =
          {
            redirect = "$out/${urlToPath val}";
            hash = fetchurl {
              inherit url;
              hash = val;
            };
            text = writeText name val;
          }
          .${key} or (throw "Unknown key: ${url}");
        source = if isHash then doOverride source0 url else source0;
      in
      ''
        mkdir -p "${dirOf path}"
        ln -s "${source}" "${path}"
      ''
    ) data'
  );
in
runCommand name (
  removeAttrs attrs [
    "name"
    "data"
    "overrides"
  ]
  // {
    passthru = (attrs.passthru or { }) // {
      data = writeText "deps.json" (builtins.toJSON data);
    };
  }
) code
