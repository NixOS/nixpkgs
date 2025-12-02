{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  jdk11,
  nixosTests,
}:

let
  pname = "jigasi";
  version = "1.1-395-g3bb4143";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/jigasi_${version}-1_all.deb";
    hash = "sha256-kBUo9TZZs3/OUrV1t813jk8Pf2vNrKEP7hZL2L2oMNE=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ dpkg ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    substituteInPlace usr/share/jigasi/jigasi.sh \
      --replace-fail "exec java" "exec ${jdk11}/bin/java"

    mkdir -p $out/{share,bin}
    mv usr/share/jigasi $out/share/
    mv etc $out/
    ln -s $out/share/jigasi/jigasi.sh $out/bin/jigasi
    runHook postInstall
  '';

  passthru.tests = {
    single-node-smoke-test = nixosTests.jitsi-meet;
  };

  meta = {
    description = "Server-side application that allows regular SIP clients to join Jitsi Meet conferences";
    mainProgram = "jigasi";
    longDescription = ''
      Jitsi Gateway to SIP: a server-side application that allows regular SIP clients to join Jitsi Meet conferences hosted by Jitsi Videobridge.
    '';
    homepage = "https://github.com/jitsi/jigasi";
    license = lib.licenses.asl20;
    teams = [ lib.teams.jitsi ];
    platforms = lib.platforms.linux;
  };
}
