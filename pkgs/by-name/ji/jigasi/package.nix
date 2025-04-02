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
  version = "1.1-374-g0ab957c";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/${pname}_${version}-1_all.deb";
    hash = "sha256-FLIIQbAjNNoCF6OBV8fpRSX/Xv5PfpP4ztvYElTfhXg=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [ dpkg ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    substituteInPlace usr/share/${pname}/${pname}.sh \
      --replace "exec java" "exec ${jdk11}/bin/java"

    mkdir -p $out/{share,bin}
    mv usr/share/${pname} $out/share/
    mv etc $out/
    ln -s $out/share/${pname}/${pname}.sh $out/bin/${pname}
    runHook postInstall
  '';

  passthru.tests = {
    single-node-smoke-test = nixosTests.jitsi-meet;
  };

  meta = with lib; {
    description = "Server-side application that allows regular SIP clients to join Jitsi Meet conferences";
    mainProgram = "jigasi";
    longDescription = ''
      Jitsi Gateway to SIP: a server-side application that allows regular SIP clients to join Jitsi Meet conferences hosted by Jitsi Videobridge.
    '';
    homepage = "https://github.com/jitsi/jigasi";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = platforms.linux;
  };
}
