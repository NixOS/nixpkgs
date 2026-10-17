{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk23,
  gradle,
  git,
  makeBinaryWrapper,
}:
let
  jdk = jdk23.override { enableJavaFX = true; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "recaf";
  version = "4.0-unstable-2024-11-11";

  src = fetchFromGitHub {
    owner = "Col-E";
    repo = "Recaf";
    rev = "40ecd657bc52670789f59d7c5fe266fa5940c6ef";
    hash = "sha256-NzrvfOCmLqmc1EPBDH8K8FuXYT8XCQddQpd7vTtmemY=";
    # Needed for automatic version detection - build script will fail without it
    leaveDotGit = true;
  };

  # FIXME: Remove when Col-E/Recaf#877 is fixed
  # Adapted from https://github.com/Col-E/Recaf/issues/865#issuecomment-2414355382
  patches = [ ./java-23-instead-of-22.patch ];

  nativeBuildInputs = [
    gradle
    git
    makeBinaryWrapper
  ];

  gradleFlags = "-Dorg.gradle.java.home=${jdk.home}";

  mitmCache = gradle.fetchDeps {
    attrPath = "recaf_4";
    data = ./deps.json;
  };

  # Required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 recaf-ui/build/libs/recaf-ui-*-all.jar $out/lib/recaf.jar
    makeWrapper ${lib.getExe jdk} $out/bin/recaf \
      --add-flags "-jar $out/lib/recaf.jar"

    runHook postInstall
  '';

  meta = {
    description = "Modern Java bytecode editor";
    homepage = "https://recaf.coley.software/";
    license = with lib.licenses; [ mit ];
    inherit (jdk.meta) platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "recaf";

    # FIXME(pluiedev): Seems that the Maven hash is platform-dependent, which is *quite* strange.
    # Requires further investigation. See https://github.com/NixOS/nixpkgs/pull/354184#discussion_r1855566964
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
  };
})
