# Adaptation of the MIT-licensed work on `sbt2nix` done by Charles O'Farrell

{ lib, fetchurl, stdenv }:
let
  defaultRepos = [
    "https://repo1.maven.org/maven2"
    "https://oss.sonatype.org/content/repositories/releases"
    "https://oss.sonatype.org/content/repositories/public"
    "https://repo.typesafe.com/typesafe/releases"
  ];
in

args@
{ # Example: "org.apache.httpcomponents"
  groupId
, # Example: "httpclient"
  artifactId
, # Example: "4.3.6"
  version
, # Example: "jdk11"
  classifier ? null
, # Example: "pom"
  type ? "jar"
, # List of maven repositories from where to fetch the artifact.
  # Example: [ http://oss.sonatype.org/content/repositories/public ].
  repos ? defaultRepos
  # The `url` and `urls` parameters, if specified should point to the artifact
  # file and will take precedence over the `repos` parameter. Only one of `url`
  # and `urls` can be specified, not both.
, url ? ""
, urls ? []
, # The rest of the arguments are just forwarded to `fetchurl`.
  ...
}:

# only one of url and urls can be specified at a time.
assert (url == "") || (urls == []);
# if repos is empty, then url or urls must be specified.
assert (repos != []) || (url != "") || (urls != []);

let
  name_ =
    lib.concatStrings [
      (lib.replaceStrings ["."] ["_"] groupId) "_"
      (lib.replaceStrings ["."] ["_"] artifactId) "-"
      version
    ];
  mkArtifactUrl = repoUrl:
    lib.concatStringsSep "/" [
      (lib.removeSuffix "/" repoUrl)
      (lib.replaceStrings ["."] ["/"] groupId)
      artifactId
      version
      "${artifactId}-${version}${
        lib.optionalString (!isNull classifier) "-${classifier}"
      }.${type}"
    ];
  urls_ =
    if url != "" then [url]
    else if urls != [] then urls
    else map mkArtifactUrl repos;
  artifact =
    fetchurl (
      builtins.removeAttrs args
        ["groupId" "artifactId" "version" "classifier" "repos" "type" "url"]
        // { urls = urls_; name = "${name_}.${type}"; }
    );
in
  stdenv.mkDerivation {
    name = name_;
    phases = "installPhase fixupPhase";
    # By moving the artifact to $out/share/java we make it discoverable by java
    # packages that mention this derivation in their buildInputs.
    installPhase = ''
      mkdir -p $out/share/java
      ln -s ${artifact} $out/share/java/${artifactId}-${version}.${type}
    '';
    # We also add an attribute to easily obtain the path to the artifact
    passthru."${type}" = artifact;
  }
