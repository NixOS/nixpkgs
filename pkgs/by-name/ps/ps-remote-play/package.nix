{
  stdenvNoCC,
  fetchurl,
  _7zz,
  cpio,
  xar,
  xcbuild,
  versionCheckHook,
  writeShellScript,
  lib,
}:

stdenvNoCC.mkDerivation {
  pname = "ps-remote-play";
  version = "8.0.0";
  src = fetchurl {
    url = "https://web.archive.org/web/20250519143727/https://remoteplay.dl.playstation.net/remoteplay/module/mac/RemotePlayInstaller.pkg";
    hash = "sha256-+iyK9RcaFLqVlRZaHMGxxlMpxkGgCuP+zzW12xOjms4=";
  };
  buildInputs = [
    _7zz
    cpio
    xar
  ];
  sourceRoot = ".";
  unpackPhase = ''
    runHook preUnpack
    7zz x $src -o$TMPDIR
    cd $TMPDIR
    cat RemotePlay.pkg/Payload | gunzip -dc | cpio -i
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    mv RemotePlay.app $out/Applications
    runHook postInstall
  '';
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    ${xcbuild}/bin/PlistBuddy -c "Print :CFBundleShortVersionString" "$1"
  '';
  versionCheckProgramArg = [
    "${placeholder "out"}/Applications/RemotePlay.app/Contents/Info.plist"
  ];
  doInstallCheck = true;
  meta = {
    homepage = "https://remoteplay.dl.playstation.net/remoteplay/lang/gb/";
    maintainers = with lib.maintainers; [ ohheyrj ];
    description = "PS Remote Play is a free app that lets you stream and play your PS5 or PS4 games on compatible devices like smartphones, tablets, PCs, and Macs, allowing you to game remotely over Wi-Fi or mobile data.";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
