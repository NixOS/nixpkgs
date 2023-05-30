{ lib, fetchFromGitHub, makeWrapper, jdk11, gradle_6, which }:

let
  pname = "freeplane";
  version = "1.9.14";

  src_sha256 = "UiXtGJs+hibB63BaDDLXgjt3INBs+NfMsKcX2Q/kxKw=";
  emoji_outputHash = "w96or4lpKCRK8A5HaB4Eakr7oVSiQALJ9tCJvKZaM34=";

  jdk = jdk11;
  gradle = gradle_6;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    sha256 = src_sha256;
  };

  gradleOpts = {
    flags = [ "-Dorg.gradle.java.home=${jdk}" /*"-x" "test"*/ ];
    depsHash = "sha256-dasM+1X4o7OwX1C0Gb4WUIiSHOSYFPLJkL+dZSTG/hE=";
    lockfileTree = ./lockfiles;
  };

  emoji = gradle.buildPackage {
    name = "${pname}-emoji";
    inherit src;

    nativeBuildInputs = [ jdk ];
    gradleOpts = gradleOpts // { buildSubcommand = ":freeplane:downloadEmoji"; };
    doCheck = false;

    installPhase = ''
      mkdir -p $out/emoji/txt $out/resources/images
      cp freeplane/build/emoji/txt/emojilist.txt $out/emoji/txt
      cp -r freeplane/build/emoji/resources/images/emoji/. $out/resources/images/emoji
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = emoji_outputHash;
  };

in gradle.buildPackage {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper jdk ];

  gradleOpts = gradleOpts // {
    flags = gradleOpts.flags ++ [ "-x" ":freeplane:downloadEmoji" ];
  };

  preBuild = ''
    mkdir -p -- ./freeplane/build/emoji/{txt,resources/images}
    cp ${emoji}/emoji/txt/emojilist.txt ./freeplane/build/emoji/txt/emojilist.txt
    cp -r ${emoji}/resources/images/emoji ./freeplane/build/emoji/resources/images/emoji
  '';

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

  meta = with lib; {
    description = "Mind-mapping software";
    homepage = "https://freeplane.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
