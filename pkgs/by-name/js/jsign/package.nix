{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  makeWrapper,
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
  # e.g. 7.2-SNAPSHOT
  version = "7.1";

  src = fetchFromGitHub {
    owner = "ebourg";
    repo = "jsign";
    tag = version;
    hash = "sha256-+ZErUCTbAI4uzhZGVQ5+awi4N4hnL3RD6SuoNdiXxBs=";
  };

  # To get libraries from LD_LIBRARY_PATH in addition to /usr/lib
  # Merged upstream, will land in 7.2
  patches = [
    (fetchpatch2 {
      name = "get-libs-from-ld_library_path.patch";
      url = "https://github.com/ebourg/jsign/commit/8f77c9befe15cef4232d7e3485a3664e1b2e4086.patch?full_index=1";
      hash = "sha256-GNFT6IFUgPEnNeRfy1JK2LaRgSbSxkFiBfyFGQ7Y+II=";
    })
  ];

  mvnHash = "sha256-k/04IHQ90OxSlOzstCTe2QhddZNpqPFsTqkVLjLHArM=";

  nativeBuildInputs = [ makeWrapper ];

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

  meta = with lib; {
    description = "Authenticode signing for Windows executables, installers & scripts";
    homepage = "https://ebourg.github.io/jsign";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [
      johnazoidberg
    ];
    mainProgram = "jsign";
  };
}
