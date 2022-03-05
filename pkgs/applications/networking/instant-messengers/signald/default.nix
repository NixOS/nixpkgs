{ lib, stdenv, fetchurl, fetchFromGitLab, jdk17_headless, coreutils, gradle_6, git, perl
, makeWrapper, fetchpatch, substituteAll
}:

let
  pname = "signald";
  version = "0.17.0";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-eN6lEs6PuRczbzQZmGlNf6Ahp4FbWpA3EArlATEiZHU=";
  };

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "${pname}-deps";
    inherit src version;
    nativeBuildInputs = [ gradle_6 perl ];
    patches = [ ./0001-Fetch-buildconfig-during-gradle-build-inside-Nix-FOD.patch ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon build
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/''${\($5 =~ s/okio-jvm/okio/r)}" #e' \
        | sh
    '';
    # Don't move info to share/
    forceShare = [ "dummy" ];
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    # Downloaded jars differ by platform
    outputHash = {
      x86_64-linux = "sha256-kZ25p+lIkOqNoFFBgJRYFcvKJenKICVa1PasaaEHmRA=";
      aarch64-linux = "sha256-CbFNigp3R7ETX0uXv6PNuhDpmPc4sowbWmwZ+5txXQs=";
    }.${stdenv.system} or (throw "Unsupported platform");
  };

in stdenv.mkDerivation rec {
  inherit pname src version;

  patches = [
    (substituteAll {
      src = ./0002-buildconfig-local-deps-fixes.patch;
      inherit deps;
    })
  ];

  buildPhase = ''
    runHook preBuild

    export GRADLE_USER_HOME=$(mktemp -d)

    gradle --offline --no-daemon distTar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    tar xvf ./build/distributions/signald.tar --strip-components=1 --directory $out/
    wrapProgram $out/bin/signald \
      --prefix PATH : ${lib.makeBinPath [ coreutils ]} \
      --set JAVA_HOME "${jdk17_headless}"

    runHook postInstall
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
    maintainers = with maintainers; [ expipiplus1 ma27 ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
