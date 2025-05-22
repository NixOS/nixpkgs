{
  lib,
  stdenv,
  fetchFromGitHub,
  gpx-animator,
  gradle_8,
  jdk17,
  runtimeShell,
}:

let
  jdk = jdk17;
  gradle = gradle_8.override { java = jdk; };
in
stdenv.mkDerivation rec {
  pname = "gpx-animator";
  version = "1.8.2";

  nativeBuildInputs = [ gradle ];

  src = fetchFromGitHub {
    owner = "gpx-animator";
    repo = "gpx-animator";
    rev = "v${version}";
    hash = "sha256-U6nrS7utnUCohCzkOdmehtSdu+5d0KJF81mXWc/666A=";
  };

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  # We only need `gradleBuildTask = "shadowJar"` instead of the slower default `gradleBuildTask
  # = "assemble"` (which also generates tarballs, etc) to generate the final .jar. However, the
  # shadowJar task doesn't have dependencies set up correctly so it won't create the
  # `version.txt` file and the resulting application will say "UNKNOWN_VERSION" in the titlebar
  # and everywhere else. As a side effect, we don't need doCheck = true either because the
  # assemble task also runs tests.

  __darwinAllowLocalNetworking = true;

  # Most other java packages use `jre_minimal` with extra modules rather than the full `jdk` as
  # the runtime dependency. But gpx-animator uses javax modules that afaik cannot just be added
  # as modules in jre_minimal.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/gpx-animator}
    cp build/libs/gpx-animator-${version}-all.jar $out/share/gpx-animator
    cp build/resources/main/version.txt $out/share/gpx-animator
    cat << EOF > $out/bin/gpx-animator
    #!${runtimeShell}
    exec ${jdk}/bin/java -jar $out/share/gpx-animator/gpx-animator-${version}-all.jar "\$@"
    EOF
    chmod a+x $out/bin/gpx-animator

    runHook postInstall
  '';

  meta = {
    description = "GPX track to video animator";
    homepage = "https://gpx-animator.app";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.markasoftware ];
    mainProgram = "gpx-animator";
    platforms = lib.platforms.unix;
  };
}
