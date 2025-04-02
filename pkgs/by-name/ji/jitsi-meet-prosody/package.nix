{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "jitsi-meet-prosody";
  version = "1.0.8499";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/${pname}_${version}-1_all.deb";
    sha256 = "U+Xy0uFdH4vYx9GYuwWD5o/K6pMRlqM0QJdWFBJXNls=";
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

  meta = with lib; {
    description = "Prosody configuration for Jitsi Meet";
    longDescription = ''
      This package contains configuration for Prosody to be used with Jitsi Meet.
    '';
    homepage = "https://github.com/jitsi/jitsi-meet/";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = platforms.linux;
  };
}
