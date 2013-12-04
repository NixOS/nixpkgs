x@{builderDefsPackage
  , jre, unzip
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="vue";
    version="3.2.2";
    name="${baseName}-${version}";
    url="releases.atech.tufts.edu/jenkins/job/VUE/64/deployedArtifacts/download/artifact.2";
    hash="0sb1kgan8fvph2cqfxk3906cwx5wy83zni2vlz4zzi6yg4zvfxld";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doDeploy"];

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out"/{share/vue,bin}
    cp ${src} "$out/share/vue/vue.jar"
    echo '#!${a.stdenv.shell}' >> "$out/bin/vue" 
    echo '${a.jre}/bin/java -jar "'"$out/share/vue/vue.jar"'" "$@"' >> "$out/bin/vue" 
    chmod a+x "$out/bin/vue"
  '' ["addInputs" "defEnsureDir"];
      
  meta = {
    description = "Visual Understanding Environment - mind mapping software";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "free-noncopyleft"; # Apache License fork, actually
  };
}) x

