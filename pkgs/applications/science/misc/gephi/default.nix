{stdenv, fetchurl, jdk}:

with stdenv.lib;

let version = "0.9.1"; in
stdenv.mkDerivation {
  name = "gephi-${version}";

  src = fetchurl {
    url = "https://github.com/gephi/gephi/releases/download/v${version}/gephi-${version}-linux.tar.gz";
    sha256 = "f1d54157302df05a53b94e1518880c949c43ba4ab21e52d57f3edcbdaa06c7ee";
  };

  meta = {
    inherit version;
    description = "A platform for visualizing and manipulating large graphs";
    homepage = https://gephi.org;
    license = licenses.gpl3;
    maintainers = [maintainers.taeer];
    platforms = platforms.linux;
  };

  buildInputs = [jdk];

  configurePhase = "
    echo \"jdkhome=${jdk}\" >> etc/gephi.conf
  ";

  dontBuild = true;

  installPhase = "
    mkdir $out
    for a in ./*; do
      mv $a $out
    done
  ";
}
