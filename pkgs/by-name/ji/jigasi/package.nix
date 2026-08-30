{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  jdk17_headless,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jigasi";
  version = "1.1-412-ge9a3acc";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/jigasi_${finalAttrs.version}-1_all.deb";
    hash = "sha256-NlJxfUyUGUqyk8rQAtykZhyAhMapmTvca42HaG1MRJU=";
  };

  nativeBuildInputs = [ dpkg ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    substituteInPlace usr/share/jigasi/jigasi.sh \
      --replace-fail "exec java" "exec ${lib.getExe jdk17_headless}"

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
})
