{ lib, stdenv, fetchurl, fetchgit, jre, coreutils, gradle_6, git, perl
, makeWrapper }:

let
  pname = "signald";

  version = "0.13.1";

  # This package uses the .git directory
  src = fetchgit {
    url = "https://gitlab.com/signald/signald";
    rev = version;
    sha256 = "1ilmg0i1kw2yc7m3hxw1bqdpl3i9wwbj8623qmz9cxhhavbcd5i7";
    leaveDotGit = true;
  };

  buildConfigJar = fetchurl {
    url = "https://dl.bintray.com/mfuerstenau/maven/gradle/plugin/de/fuerstenau/BuildConfigPlugin/1.1.8/BuildConfigPlugin-1.1.8.jar";
    sha256 = "0y1f42y7ilm3ykgnm6s3ks54d71n8lsy5649xgd9ahv28lj05x9f";
  };

  patches = [ ./git-describe-always.patch ./gradle-plugin.patch ];

  postPatch = ''
    patchShebangs gradlew
    sed -i -e 's|BuildConfig.jar|${buildConfigJar}|' build.gradle
  '';

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src version postPatch patches;
    nativeBuildInputs = [ gradle_6 perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon build
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/''${\($5 =~ s/-jvm//r)}" #e' \
        | sh
    '';
    # Don't move info to share/
    forceShare = [ "dummy" ];
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0w8ixp1l0ch1jc2dqzxdx3ljlh17hpgns2ba7qvj43nr4prl71l7";
  };

in stdenv.mkDerivation rec {
  inherit pname src version postPatch patches;

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)

    # Use the local packages from -deps
    sed -i -e 's|mavenCentral()|mavenLocal(); maven { url uri("${deps}") }|' build.gradle

    gradle --offline --no-daemon distTar
  '';

  installPhase = ''
    mkdir -p $out
    tar xvf ./build/distributions/signald.tar --strip-components=1 --directory $out/
    wrapProgram $out/bin/signald \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]} \
      --set JAVA_HOME "${jre}"
  '';

  nativeBuildInputs = [ git gradle_6 makeWrapper ];

  doCheck = true;

  meta = with lib; {
    description = "Unofficial daemon for interacting with Signal";
    longDescription = ''
      Signald is a daemon that facilitates communication over Signal.  It is
      unofficial, unapproved, and not nearly as secure as the real Signal
      clients.
    '';
    homepage = "https://signald.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.unix;
  };
}
