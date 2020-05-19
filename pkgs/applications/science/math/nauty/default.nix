{ stdenv
, lib
, fetchurl
}:
stdenv.mkDerivation rec {
  pname = "nauty";
  version = "27r1";
  src = fetchurl {
    url = "http://pallini.di.uniroma1.it/nauty${version}.tar.gz";
    sha256 = "1nym0p2djws8ylkpr0kgpxfa6fxdlh46cmvz0gn5vd02jzgs0aww";
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
    # I'm not sure if the filename will remain the same for future changelog or
    # if it will track changes to minor releases. Lets see. Better than nothing
    # in any case.
    changelog = "http://pallini.di.uniroma1.it/changes24-27.txt";
    homepage = "http://pallini.di.uniroma1.it/";
  };
}
