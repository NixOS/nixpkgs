{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  makeBinaryWrapper,
  jre_headless,
  maven,
  pcsclite,
  yubico-piv-tool,
  opensc,
}:

let
  jre = jre_headless;
in
maven.buildMavenPackage rec {
  pname = "jsign";
  # For build from non-release, increment version by one and add -SNAPSHOT
  # e.g. 7.3-SNAPSHOT
  version = "7.2";

  src = fetchFromGitHub {
    owner = "ebourg";
    repo = "jsign";
    tag = version;
    hash = "sha256-ngAwtd4C3KeLq9sM15B8tWS34AH81azYEjXg3+Gy5NA=";
  };

  mvnHash = "sha256-N91gwM3vsDZQM/BptF5RgRQ/A8g56NOJ6bc2SkxLnBs=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  # The tests try to access the network
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    install -Dm644 jsign/target/jsign-${version}.jar $out/share/jsign.jar

    makeWrapper ${jre}/bin/java $out/bin/jsign \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          yubico-piv-tool
          opensc
        ]
      } \
      --add-flags "-Dsun.security.smartcardio.library=${lib.getLib pcsclite}/lib/libpcsclite.so.1 -jar $out/share/jsign.jar"

    runHook postInstall
  '';

  meta = {
    description = "Authenticode signing for Windows executables, installers & scripts";
    homepage = "https://ebourg.github.io/jsign";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      johnazoidberg
    ];
    mainProgram = "jsign";
    # Build doesn't work, upstream says running the .jar is supported on darwin though
    broken = stdenv.hostPlatform.isDarwin;
  };
}
