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
  version = "1.0.8746";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "jitsi-meet";
    tag = lib.last (lib.splitVersion finalAttrs.version);
    hash = "sha256-ZTWu51i6zG6iGftuWzfnbxwiU4dy1EiJYm11DmU6F6Q=";
  };

  env = {
    makeFlags = "source-package";
    makeCacheWritable = true;
    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) src;
      hash = "sha256-CX2BY9BOt+gSVoH6aI/ncFZaf8vLtV34dUQvakgat3c=";
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

  meta = with lib; {
    description = "Secure, Simple and Scalable Video Conferences";
    longDescription = ''
      Jitsi Meet is an open-source (Apache) WebRTC JavaScript application that uses Jitsi Videobridge
      to provide high quality, secure and scalable video conferences.
    '';
    homepage = "https://github.com/jitsi/jitsi-meet";
    license = licenses.asl20;
    teams = [ teams.jitsi ];
    platforms = platforms.all;
    inherit (olm.meta) knownVulnerabilities;
  };
})
