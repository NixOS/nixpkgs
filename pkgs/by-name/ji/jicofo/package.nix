{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  jre_headless,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jicofo";
  version = "1.0-1233";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/jicofo_${finalAttrs.version}-1_all.deb";
    hash = "sha256-/tWzzBdcVa1GC/jDPmwB4h9KPDtniMxDYQz8AEyb1+Q=";
  };

  dontBuild = true;

  nativeBuildInputs = [ dpkg ];

  installPhase = ''
    runHook preInstall
    substituteInPlace usr/share/jicofo/jicofo.sh \
      --replace "exec java" "exec ${jre_headless}/bin/java"

    mkdir -p $out/{share,bin}
    mv usr/share/jicofo $out/share/
    mv etc $out/
    cp ${./logging.properties-journal} $out/etc/jitsi/jicofo/logging.properties-journal
    ln -s $out/share/jicofo/jicofo.sh $out/bin/jicofo
    runHook postInstall
  '';

  passthru.tests = {
    single-node-smoke-test = nixosTests.jitsi-meet;
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Server side focus component used in Jitsi Meet conferences";
    mainProgram = "jicofo";
    longDescription = ''
      JItsi COnference FOcus is a server side focus component used in Jitsi Meet conferences.
    '';
    homepage = "https://github.com/jitsi/jicofo";
    license = lib.licenses.asl20;
    teams = [ lib.teams.jitsi ];
    platforms = lib.platforms.linux;
  };
})
