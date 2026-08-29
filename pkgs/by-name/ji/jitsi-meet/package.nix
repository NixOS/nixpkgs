{
  lib,
  stdenv,
  nixosTests,

  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,

  libarchive,
  nodejs,

  olm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jitsi-meet";
  version = "1.0.9365";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jitsi-meet";
    tag = lib.last (lib.splitVersion finalAttrs.version);
    hash = "sha256-gAXY40jvQjGhitbpWjJ+C8GZwuRu/zyJw2NN5yf/l6o=";
  };

  env = {
    makeFlags = "source-package";
    makeCacheWritable = true;
    forceGitDeps = true;
    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) src;
      hash = "sha256-5fGaX8VFCCMkTeQuhFPwd9W7cBNVML/bVYLODq07s5w=";
      forceGitDeps = true;
    };
  };

  nativeBuildInputs = [
    libarchive
    nodejs
    npmHooks.npmConfigHook
  ];

  # yes, the only way in the build system is to generate a tarball and extract
  # it immediately after
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    bsdtar -xf jitsi-meet.tar.bz2 -C $out --strip-components 1
    runHook postInstall
  '';

  # Test requires running Jitsi Videobridge and Jicofo which are Linux-only
  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    single-host-smoke-test = nixosTests.jitsi-meet;
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Secure, Simple and Scalable Video Conferences";
    longDescription = ''
      Jitsi Meet is an open-source (Apache) WebRTC JavaScript application that uses Jitsi Videobridge
      to provide high quality, secure and scalable video conferences.
    '';
    homepage = "https://github.com/jitsi/jitsi-meet";
    license = lib.licenses.asl20;
    teams = [ lib.teams.jitsi ];
    inherit (nodejs.meta) platforms;
    inherit (olm.meta) knownVulnerabilities;
  };
})
