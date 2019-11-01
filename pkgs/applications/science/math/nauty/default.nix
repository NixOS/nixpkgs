{ stdenv
, lib
, fetchurl
}:
stdenv.mkDerivation rec {
  pname = "nauty";
  version = "26r12";
  src = fetchurl {
    url = "http://pallini.di.uniroma1.it/nauty${version}.tar.gz";
    sha256 = "1p4mxf8q5wm47nxyskxbqwa5p1vvkycv1zgswvnk9nsn6vff0al6";
  };
  outputs = [ "out" "dev" ];
  configureFlags = {
    # Prevent nauty from sniffing some cpu features. While those are very
    # widely available, it can lead to nasty bugs when they are not available:
    # https://groups.google.com/forum/#!topic/sage-packaging/Pe4SRDNYlhA
    default        = [ "--disable-clz" "--disable-popcnt" ];
    westmere       = [ "--disable-clz" ];
    sandybridge    = [ "--disable-clz" ];
    ivybridge      = [ "--disable-clz" ];
  }.${stdenv.hostPlatform.platform.gcc.arch or "default"} or [];
  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/nauty} "$dev"/{lib,include/nauty}

    find . -type f -perm -111 \! -name '*.*' \! -name configure -exec cp '{}' "$out/bin" \;
    cp [Rr][Ee][Aa][Dd]* COPYRIGHT This* [Cc]hange* "$out/share/doc/nauty"

    cp *.h "$dev/include/nauty"
    for i in *.a; do
      cp "$i" "$dev/lib/lib$i";
    done
  '';
  checkTarget = "checks";
  meta = with lib; {
    inherit version;
    description = ''Programs for computing automorphism groups of graphs and digraphs'';
    license = licenses.asl20;
    maintainers = with maintainers; [ raskin timokau ];
    platforms = platforms.unix;
    homepage = http://pallini.di.uniroma1.it/;
  };
}
