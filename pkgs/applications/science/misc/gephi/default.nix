{stdenv, fetchurl, jdk}:

with stdenv.lib;

let version = "0.9.2"; in
stdenv.mkDerivation {
  name = "gephi-${version}";

  src = fetchurl {
    url = "https://github.com/gephi/gephi/releases/download/v${version}/gephi-${version}-linux.tar.gz";
    sha256 = "1wr3rka8j2y10nnwbg27iaxkbrp4d7d07ccs9n94yqv6wqawj5z8";
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
