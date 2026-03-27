{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jitsi-meet-prosody";
  version = "1.0.8737";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/jitsi-meet-prosody_${finalAttrs.version}-1_all.deb";
    sha256 = "fZs1ng1mtxwXgJAQqxAlrNrqUQJc9fGlxJKwuTJLENc=";
  };

  nativeBuildInputs = [ dpkg ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    mv usr/share/jitsi-meet/prosody-plugins $out/share/
    runHook postInstall
  '';

  passthru.tests = {
    single-node-smoke-test = nixosTests.jitsi-meet;
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Prosody configuration for Jitsi Meet";
    longDescription = ''
      This package contains configuration for Prosody to be used with Jitsi Meet.
    '';
    homepage = "https://github.com/jitsi/jitsi-meet/";
    license = lib.licenses.asl20;
    teams = [ lib.teams.jitsi ];
    platforms = lib.platforms.linux;
  };
})
