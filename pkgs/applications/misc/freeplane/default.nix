{ stdenv, lib, fetchFromGitHub, makeWrapper, jdk11, gradle_6, which }:

let
  jdk = jdk11;
  gradle = gradle_6;

in stdenv.mkDerivation rec {
  pname = "freeplane";
  version = "1.9.14";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    sha256 = "UiXtGJs+hibB63BaDDLXgjt3INBs+NfMsKcX2Q/kxKw=";
  };

  nativeBuildInputs = [ makeWrapper jdk gradle ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk}"
    "-x" "test"
  ];

  gradleBuildTask = "build";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share

    cp -a ./BIN/. $out/share/${pname}
    makeWrapper $out/share/${pname}/${pname}.sh $out/bin/${pname} \
      --set FREEPLANE_BASE_DIR $out/share/${pname} \
      --set JAVA_HOME ${jdk} \
      --prefix PATH : ${lib.makeBinPath [ jdk which ]}
    runHook postInstall
  '';

  passthru.updateDeps = gradle.updateDeps {
    inherit pname;
    postBuild = ''
      gradle :freeplane:downloadEmoji
    '';
  };

  meta = with lib; {
    description = "Mind-mapping software";
    homepage = "https://freeplane.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
