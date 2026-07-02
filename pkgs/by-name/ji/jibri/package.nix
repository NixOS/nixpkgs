{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  jdk11_headless,
  makeWrapper,
  writeText,
  xorg-server,
  xf86-video-dummy,
  nixosTests,
}:

let
  xorgModulePaths = writeText "module-paths" ''
    Section "Files"
      ModulePath "${xorg-server}/lib/xorg/modules
      ModulePath "${xorg-server}/lib/xorg/extensions
      ModulePath "${xorg-server}/lib/xorg/drivers
      ModulePath "${xf86-video-dummy}/lib/xorg/modules/drivers
    EndSection
  '';

in
stdenv.mkDerivation (finalAttrs: {
  pname = "jibri";
  version = "8.0-183-g7b406bf";
  src = fetchurl {
    url = "https://download.jitsi.org/stable/jibri_${finalAttrs.version}-1_all.deb";
    sha256 = "QF7BkLizAsEzjC6PdTyPFAFf82AzukTnxHxLHyz5Kco=";
  };

  dontBuild = true;
  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/jitsi/jibri,etc/jitsi/jibri}
    mv etc/jitsi/jibri/* $out/etc/jitsi/jibri/
    mv opt/jitsi/jibri/* $out/opt/jitsi/jibri/

    cat '${xorgModulePaths}' >> $out/etc/jitsi/jibri/xorg-video-dummy.conf

    makeWrapper ${jdk11_headless}/bin/java $out/bin/jibri --add-flags "-jar $out/opt/jitsi/jibri/jibri.jar"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  passthru.tests = { inherit (nixosTests) jibri; };

  meta = {
    description = "JItsi BRoadcasting Infrastructure";
    mainProgram = "jibri";
    longDescription = ''
      Jibri provides services for recording or streaming a Jitsi Meet conference.
      It works by launching a Chrome instance rendered in a virtual framebuffer and capturing and
      encoding the output with ffmpeg. It is intended to be run on a separate machine (or a VM), with
      no other applications using the display or audio devices. Only one recording at a time is
      supported on a single jibri.
    '';
    homepage = "https://github.com/jitsi/jibri";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    teams = [ lib.teams.jitsi ];
    platforms = lib.platforms.linux;
  };
})
