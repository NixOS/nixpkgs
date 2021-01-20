{ stdenv
, lib
, fetchurl
}:
stdenv.mkDerivation rec {
  pname = "nauty";
  version = "27r1";
  src = fetchurl {
    url = "http://pallini.di.uniroma1.it/nauty${version}.tar.gz";
    sha256 = "0xsfqfcknbd6g6wzpa5l7crmmk3bf3zjh37rhylq6b20dqcmvjkn";
  };
  outputs = [ "out" "dev" ];
  configureFlags = [
    # Prevent nauty from sniffing some cpu features. While those are very
    # widely available, it can lead to nasty bugs when they are not available:
    # https://groups.google.com/forum/#!topic/sage-packaging/Pe4SRDNYlhA
    "--${if stdenv.hostPlatform.sse4_2Support then "enable" else "disable"}-popcnt"
    "--${if stdenv.hostPlatform.sse4_aSupport then "enable" else "disable"}-clz"
  ];
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
    maintainers = teams.sage.members;
    platforms = platforms.unix;
    # I'm not sure if the filename will remain the same for future changelog or
    # if it will track changes to minor releases. Lets see. Better than nothing
    # in any case.
    changelog = "http://pallini.di.uniroma1.it/changes24-27.txt";
    homepage = "http://pallini.di.uniroma1.it/";
  };
}
