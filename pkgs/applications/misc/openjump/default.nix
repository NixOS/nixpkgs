{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "openjump-1.3.1";

  src = fetchurl {
    url = mirror://sourceforge/jump-pilot/OpenJUMP/1.3.1/openjump-1.3.1.zip;
    sha256 = "0y4z53yx0x7rp3c8rnj028ni3gr47r35apgcpqp3jl7r2di6zgqm";
  };

  # ln jump.log hack: a different user will probably get a permission denied
  # error. Still this is better than getting it always.
  # TODO: build from source and patch this
  unpackPhase = ''
    mkdir -p $out/bin;
    cd $out; unzip $src
    s=$out/bin/OpenJump
    dir=$(echo $out/openjump-*)
    cat >> $s << EOF
    #!/bin/sh
    cd $dir/bin
    exec /bin/sh openjump.sh
    EOF
    chmod +x $s
    ln -s /tmp/openjump.log $dir/bin/jump.log
  '';

  installPhase = ":";

  buildInputs = [unzip];

  meta = {
    description = "Open source Geographic Information System (GIS) written in the Java programming language";
    homepage = http://www.openjump.org/index.html;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
