{ stdenv, fetchFromGitHub, fetchgit, sbt, jre, makeWrapper, bash }:

stdenv.mkDerivation rec {
  pname = "bfg-repo-cleaner";
  version = "1.12.15";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "rtyley";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "0wxr16d86zkf1kz1qyz215jansydn09fmnikyc0hw98d5hn2apla";
  };

  buildInputs = [ jre sbt makeWrapper bash ];

  buildPhase = ''
    sbt bfg/assembly
    '';

  installPhase = ''
    mkdir -p $out/bin $out/share/bfg
    cp bfg/target/bfg-${version}-unknown.jar $out/share/bfg/bfg-${version}.jar
    makeWrapper "${jre}/bin/java" "$out"/bin/bfg --add-flags "-jar $out/share/bfg/bfg-${version}.jar"
  '';

  meta = with stdenv.lib; {
    homepage = "https://rtyley.github.io/bfg-repo-cleaner";
    description = "Fast removal of blobs in git repos like git-filter-branch";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.leenaars ];
    platforms = platforms.all;
  };

}
