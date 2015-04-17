{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "vue-${version}";
  version = "3.2.2";
  src = fetchurl {
    url = "releases.atech.tufts.edu/jenkins/job/VUE/64/deployedArtifacts/download/artifact.2";
    sha256 = "0sb1kgan8fvph2cqfxk3906cwx5wy83zni2vlz4zzi6yg4zvfxld";
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
