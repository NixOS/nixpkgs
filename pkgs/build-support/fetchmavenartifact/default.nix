# Adaptation of the MIT-licensed work on `sbt2nix` done by Charles O'Farrell

{
  lib,
  fetchurl,
  stdenv,
}:
let
  defaultRepos = [
    "https://repo1.maven.org/maven2"
    "https://oss.sonatype.org/content/repositories/releases"
    "https://oss.sonatype.org/content/repositories/public"
    "https://repo.typesafe.com/typesafe/releases"
  ];
in

args@{
  # Example: "org.apache.httpcomponents"
  groupId,
  # Example: "httpclient"
  artifactId,
  # Example: "4.3.6"
  version,
  # Example: "jdk11"
  classifier ? null,
  # List of maven repositories from where to fetch the artifact.
  # Example: [ http://oss.sonatype.org/content/repositories/public ].
  repos ? defaultRepos,
  # The `url` and `urls` parameters, if specified should point to the JAR
  # file and will take precedence over the `repos` parameter. Only one of `url`
  # and `urls` can be specified, not both.
  url ? "",
  urls ? [ ],
  # Metadata
  meta ? { },
  # The rest of the arguments are just forwarded to `fetchurl`.
  ...
}:

# only one of url and urls can be specified at a time.
assert (url == "") || (urls == [ ]);
# if repos is empty, then url or urls must be specified.
assert (repos != [ ]) || (url != "") || (urls != [ ]);

let
  pname =
    (lib.replaceStrings [ "." ] [ "_" ] groupId)
    + "_"
    + (lib.replaceStrings [ "." ] [ "_" ] artifactId);
  suffix = lib.optionalString (classifier != null) "-${classifier}";
  filename = "${artifactId}-${version}${suffix}.jar";
  mkJarUrl =
    repoUrl:
    lib.concatStringsSep "/" [
      (lib.removeSuffix "/" repoUrl)
      (lib.replaceStrings [ "." ] [ "/" ] groupId)
      artifactId
      version
      filename
    ];
  urls_ =
    if url != "" then
      [ url ]
    else if urls != [ ] then
      urls
    else
      map mkJarUrl repos;
  jar = fetchurl (
    removeAttrs args [
      "groupId"
      "artifactId"
      "version"
      "classifier"
      "repos"
      "url"
      "meta"
    ]
    // {
      urls = urls_;
      name = "${pname}-${version}.jar";
    }
  );
in
stdenv.mkDerivation {
  inherit pname version meta;
  dontUnpack = true;
  # By moving the jar to $out/share/java we make it discoverable by java
  # packages packages that mention this derivation in their buildInputs.
  installPhase = ''
    mkdir -p $out/share/java
    ln -s ${jar} $out/share/java/${filename}
  '';
  # We also add a `jar` attribute that can be used to easily obtain the path
  # to the downloaded jar file.
  passthru.jar = jar;
}
