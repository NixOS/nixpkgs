{ lib, stdenv, fetchFromGitHub, gradle_6, perl, makeWrapper, jdk11, gsettings-desktop-schemas }:

let
  version = "0.9.3-3";

  src = fetchFromGitHub {
    owner = "mucommander";
    repo = "mucommander";
    rev = version;
    sha256 = "1zhglsx3b5k6np3ppfkkrqz9wg0j7ip598xxfgn75gjl020w0can";
  };

  postPatch = ''
    # there is no .git anyway
    substituteInPlace build.gradle \
      --replace "git = org.ajoberstar.grgit.Grgit.open(file('.'))"  "" \
      --replace "revision = git.head().id"                          "revision = 'abcdefgh'" \
      --replace "proguard.enabled =" "// proguard.enabled =" \
      --replace "version = '0.9.4'" "version = '${version}'"

    # disable gradle plugins with native code and their targets
    perl -i.bak1 -pe "s#(^\s*id '.+' version '.+'$)#// \1#" build.gradle
    perl -i.bak2 -pe "s#(.*)#// \1# if /^(buildscript|task portable|task nsis|task proguard|task tgz|task\(afterEclipseImport\)|launch4j|macAppBundle|buildRpm|buildDeb|shadowJar)/ ... /^}/" build.gradle

    # fix source encoding
    find . -type f -name build.gradle \
      -exec perl -i.bak3 -pe "s#(repositories\.jcenter\(\))#
                                \1
                                compileJava.options.encoding = 'UTF-8'
                                compileTestJava.options.encoding = 'UTF-8'
                               #" {} \;
  '';

  # fake build to pre-download deps into fixed-output derivation
  deps = stdenv.mkDerivation {
    pname = "mucommander-deps";
    inherit version src postPatch;
    nativeBuildInputs = [ gradle_6 perl ];
    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle --no-daemon build
    '';
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    installPhase = ''
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "1v5a76pvk7llbyv2rg50wlxc2wf468l2cslz1vi20aihycbyky7j";
  };

in stdenv.mkDerivation {
  pname = "mucommander";
  inherit version src postPatch;
  nativeBuildInputs = [ gradle_6 perl makeWrapper ];

  buildPhase = ''
    export GRADLE_USER_HOME=$(mktemp -d)

    # point to offline repo
    find . -type f -name build.gradle \
      -exec perl -i.bak3 -pe "s#repositories\.jcenter\(\)#
                                repositories { mavenLocal(); maven { url '${deps}' } }
                               #" {} \;

    gradle --offline --no-daemon distTar
  '';

  installPhase = ''
    mkdir $out
    tar xvf build/distributions/mucommander-${version}.tar --directory=$out --strip=1
    wrapProgram $out/bin/mucommander \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
      --set JAVA_HOME ${jdk11}
  '';

  meta = with lib; {
    homepage = "http://www.mucommander.com/";
    description = "Cross-platform file manager";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
