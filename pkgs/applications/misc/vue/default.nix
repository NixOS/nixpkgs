{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "vue-${version}";
  version = "3.3.0";
  src = fetchurl {
    url = "http://releases.atech.tufts.edu/jenkins/job/VUE/116/deployedArtifacts/download/artifact.1";
    sha256 = "0yfzr80pw632lkayg4qfmwzrqk02y30yz8br7isyhmgkswyp5rnx";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p "$out"/{share/vue,bin}
    cp ${src} "$out/share/vue/vue.jar"
    echo '#!${stdenv.shell}' >> "$out/bin/vue"
    echo '${jre}/bin/java -jar "'"$out/share/vue/vue.jar"'" "$@"' >> "$out/bin/vue"
    chmod a+x "$out/bin/vue"
  '';

  meta = {
    description = "Visual Understanding Environment - mind mapping software";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.free; # Apache License fork, actually
  };
}
