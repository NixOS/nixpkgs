{
  lib,
  maven,
  fetchFromGitHub,
  jdk11,
  makeBinaryWrapper,
  libglvnd,
  glib,
  gtk3,
  libXtst,
  nix-update-script,
}:
let
  version = "2.21.14";
  jdk = jdk11;
in
maven.buildMavenPackage {
  pname = "recaf";
  inherit version;

  src = fetchFromGitHub {
    owner = "Col-E";
    repo = "Recaf";
    rev = "refs/tags/${version}";
    hash = "sha256-aVOVfrACawYc9VlBZ6+IHiCDGPOsVLdAvwQHdByZ584=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  mvnHash = "sha256-MPPZXQilmMaj8n5SXP7fG1Q95pH5Ydu7jU+KRS9beO8=";
  mvnJdk = jdk; # Required for tests

  # Disable flaky tests
  mvnParameters = "'-Dtest=!CompilerTest,!#testMaven+testMavenLoading'";

  installPhase =
    let
      # Required by glassgtk3
      libPath = lib.makeLibraryPath [
        libglvnd
        gtk3
        glib
        libXtst
      ];
    in
    ''
      runHook preInstall

      install -Dm644 target/recaf-${version}-*-jar-with-dependencies.jar $out/lib/recaf.jar
      makeWrapper ${lib.getExe jdk} $out/bin/recaf \
        --add-flags "-jar $out/lib/recaf.jar" \
        --prefix LD_LIBRARY_PATH : "${libPath}"

      runHook postInstall
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern Java bytecode editor";
    homepage = "https://recaf.coley.software/";
    license = with lib.licenses; [ mit ];
    inherit (jdk.meta) platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
