{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle,
  jre,
  makeWrapper,
  libadwaita,
  glib,
  gtk4,
}:
stdenv.mkDerivation (final: {
  pname = "coulomb";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "hamza-Algohary";
    repo = "Coulomb";
    tag = "v${final.version}";
    hash = "sha256-SbtFUUla0uoeDik+7CtibV/lvgUg8N81WWRp2+8wygM=";
  };

  patches = [
    ./java21.patch
  ];

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (final) pname;
    data = ./deps.json;
  };

  gradleBuildTask = "shadowJar";

  installPhase = ''
    mkdir -p $out/{bin,share/coulomb}
    cp app/build/libs/app-all.jar $out/share/coulomb/

    makeWrapper ${lib.getExe jre} $out/bin/coulomb \
      --add-flags "-jar $out/share/coulomb/app-all.jar" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libadwaita
          glib
        ]
      }"
  '';

  meta = {
    description = "A simple and elegant circuit simulator";
    maintainers = [ lib.maintainers.samw ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Only;
  };
})
