{ stdenv
, lib
, fetchurl
}:
stdenv.mkDerivation rec {
  pname = "nauty";
  version = "2.7r4";

  src = fetchurl {
    url = "https://pallini.di.uniroma1.it/nauty${builtins.replaceStrings ["."] [""] version}.tar.gz";
    sha256 = "sha256-uBDIWm/imfO0yfJKr5KcrH+VRsLzXCDh3Qrbx0CISKY=";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    # Prevent nauty from sniffing some cpu features. While those are very
    # widely available, it can lead to nasty bugs when they are not available:
    # https://groups.google.com/forum/#!topic/sage-packaging/Pe4SRDNYlhA
    "--enable-generic" # don't use -march=native
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
    description = "Programs for computing automorphism groups of graphs and digraphs";
    license = licenses.asl20;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
    # I'm not sure if the filename will remain the same for future changelog or
    # if it will track changes to minor releases. Lets see. Better than nothing
    # in any case.
    changelog = "https://pallini.di.uniroma1.it/changes24-27.txt";
    homepage = "https://pallini.di.uniroma1.it/";
  };
}
