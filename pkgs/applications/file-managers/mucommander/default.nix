{ lib
, fetchFromGitHub
, gradle_7
, makeWrapper
, jdk
, gsettings-desktop-schemas
}:

let
  version = "1.2.0-1";

  src = fetchFromGitHub {
    owner = "mucommander";
    repo = "mucommander";
    rev = version;
    sha256 = "sha256-OrtC7E/8n9uEo7zgFHYQqXV3qLpdKtxwbwZfxoOqTqA=";
  };

  postPatch = ''
    # there is no .git anyway
    substituteInPlace build.gradle \
      --replace "git = grgit.open(dir: project.rootDir)" "" \
      --replace "revision = git.head().id" "revision = '${version}'"
  '';

  gradle = gradle_7;
in
gradle.buildPackage {
  pname = "mucommander";
  inherit version src postPatch;
  nativeBuildInputs = [ makeWrapper ];
  gradleOpts.buildSubcommand = "tgz";
  gradleOpts.lockfileTree = ./lockfiles;
  gradleOpts.depsHash = "sha256-LJzowmiR7hcwtYx4W70qymWH76ZlLcsc57D0RaA5wOw=";

  installPhase = ''
    mkdir -p $out/share/mucommander
    tar xvf build/distributions/mucommander-*.tgz --directory=$out/share/mucommander

    makeWrapper $out/share/mucommander/mucommander.sh $out/bin/mucommander \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
      --set JAVA_HOME ${jdk}
  '';

  meta = with lib; {
    homepage = "https://www.mucommander.com/";
    description = "Cross-platform file manager";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jiegec ];
    platforms = platforms.all;
  };
}
