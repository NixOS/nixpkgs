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
    version="3.1.2";
    name="${baseName}-${version}";
    url="http://releases.atech.tufts.edu/vue/v${version}/VUE_3_1_2.zip";
    hash="0ga98gnp4qhcrb31cb8j0mwbrh6ym6hr4k5y4blxvyfff9c0vq47";
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
    unzip ${src}
    mkdir -p "$out"/{share/vue,bin}
    cp VUE.jar "$out/share/vue/vue.jar"
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

