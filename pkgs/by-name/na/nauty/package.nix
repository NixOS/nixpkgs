{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nauty";
  version = "2.9.3";

  src = fetchurl {
    url = "https://pallini.di.uniroma1.it/nauty${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.tar.gz";
    sha256 = "sha256-n8TtrgT4ig9Yg5hb47Oc9/iY/WzJbpa57iVFJ0PMG1s=";
  };

  outputs = [
    "out"
    "dev"
  ];

  configureFlags = [
    "--libdir=${placeholder "dev"}/lib"
    # Prevent nauty from sniffing some cpu features. While those are very
    # widely available, it can lead to nasty bugs when they are not available:
    # https://groups.google.com/forum/#!topic/sage-packaging/Pe4SRDNYlhA
    "--enable-generic" # don't use -march=native
    "--${if stdenv.hostPlatform.sse4_2Support then "enable" else "disable"}-popcnt"
    "--${if stdenv.hostPlatform.sse4_aSupport then "enable" else "disable"}-clz"
  ];

  postInstall = ''
    mkdir -p "$out/share/doc/nauty" "$dev/include/nauty"
    cp [Rr][Ee][Aa][Dd]* COPYRIGHT This* [Cc]hange* "$out/share/doc/nauty"
    cp *.h "$dev/include/nauty"
  '';

  meta = {
    description = "Programs for computing automorphism groups of graphs and digraphs";
    license = lib.licenses.asl20;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
    # The filename may change for future changelogs. Better than nothing in any case.
    changelog = "https://pallini.di.uniroma1.it/changes24-2${lib.versions.minor finalAttrs.version}.txt";
    homepage = "https://pallini.di.uniroma1.it/";
  };
})
