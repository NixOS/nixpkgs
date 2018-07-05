{ wrapCommand, fetchurl, jre, lib }:

let
  version = "2.18.7";
  jar = fetchurl {
    url = "https://github.com/broadinstitute/picard/releases/download/${version}/picard.jar";
    sha256 = "00p5wmd3kb7pr3yvsqz660fsk845dwgj76bllwjfrbiscjdyhy9f";
  };
in wrapCommand "picard" {
  inherit version;
  executable = "${jre}/bin/java";
  makeWrapperArgs = [ "--add-flags -jar" "--add-flags ${jar}"];
  meta = with lib; {
    description = "Tools for high-throughput sequencing (HTS) data and formats such as SAM/BAM/CRAM and VCF.";
    license = licenses.mit;
    homepage = https://broadinstitute.github.io/picard/;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };
}
