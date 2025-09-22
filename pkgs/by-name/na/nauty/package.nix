{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "nauty";
  version = "2.9.1";

  src = fetchurl {
    url = "https://pallini.di.uniroma1.it/nauty${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }.tar.gz";
    sha256 = "sha256-SI+pBtEKNyxy0jZMXe5I4PcwcAT75SwrzlDFLejNhz4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  # HACK: starting from 2.8.9, the makefile tries to copy .libs/*.a files unconditionally
  dontDisableStatic = true;

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
    teams = [ teams.sage ];
    platforms = platforms.unix;
    # The filename may change for future changelogs. Better than nothing in any case.
    changelog = "https://pallini.di.uniroma1.it/changes24-2${lib.versions.minor version}.txt";
    homepage = "https://pallini.di.uniroma1.it/";
  };
}
