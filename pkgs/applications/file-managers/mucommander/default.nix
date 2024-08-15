{ lib
, stdenv
, fetchFromGitHub
, gradle_7
, makeWrapper
, jdk
, gsettings-desktop-schemas
}:

let
  gradle = gradle_7;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mucommander";
  version = "1.3.0-1";

  src = fetchFromGitHub {
    owner = "mucommander";
    repo = "mucommander";
    rev = finalAttrs.version;
    sha256 = "sha256-rSHHv96L2EHQuKBSAdpfi1XGP2u9o2y4g1+65FHWFMw=";
  };

  postPatch = ''
    # there is no .git anyway
    substituteInPlace build.gradle \
      --replace "git = grgit.open(dir: project.rootDir)" "" \
      --replace "revision = git.head().id" "revision = '${finalAttrs.version}'"
  '';

  nativeBuildInputs = [ gradle makeWrapper ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleBuildTask = "tgz";

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
    mainProgram = "mucommander";
  };
})
