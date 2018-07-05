{stdenv, fetchurl, jre, wrapCommand}:

let
  version = "2.4.2";
  jar = fetchurl {
    url = "https://github.com/dkoboldt/varscan/releases/download/${version}/VarScan.v${version}.jar";
    sha256 = "0cfhshinyqgwc6i7zf8lhbfybyly2x5anrz824zyvdhzz5i69zrl";
  };
in wrapCommand "varscan" {
  inherit version;
  executable = "${jre}/bin/java";
  makeWrapperArgs = [ "--add-flags -jar" "--add-flags ${jar}" ];

  meta = with stdenv.lib; {
    description = "Variant calling and somatic mutation/CNV detection for next-generation sequencing data";
    # VarScan 2 is free for non-commercial use by academic,
    # government, and non-profit/not-for-profit institutions. A
    # commercial version of the software is available, and licensed
    # through the Office of Technology Management at Washington
    # University School of Medicine.
    license = licenses.unfree;
    homepage = https://github.com/dkoboldt/varscan;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.all;
  };
}
