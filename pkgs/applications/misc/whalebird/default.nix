{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron
, nodePackages, alsa-lib, gtk3, libxshmfence, mesa, nss }:

stdenv.mkDerivation rec {
  pname = "whalebird";
  version = "4.5.2";

  src = fetchurl {
    url = "https://github.com/h3poteto/whalebird-desktop/releases/download/${version}/Whalebird-${version}-linux-x64.deb";
    sha256 = "sha256-4ksKXVeUGICHfx014s5g9mapS751dbexBjzyqNvk02M=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    nodePackages.asar
  ];

  buildInputs = [ alsa-lib gtk3 libxshmfence mesa nss ];

  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  buildPhase = ''
    runHook preBuild

    # Necessary steps to find the tray icon
    asar extract opt/Whalebird/resources/app.asar "$TMP/work"
    substituteInPlace $TMP/work/dist/electron/main.js \
      --replace "jo,\"tray_icon.png\"" "\"$out/opt/Whalebird/resources/build/icons/tray_icon.png\""
    asar pack --unpack='{*.node,*.ftz,rect-overlay}' "$TMP/work" opt/Whalebird/resources/app.asar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    mv usr/share opt $out

    substituteInPlace $out/share/applications/whalebird.desktop \
      --replace '/opt/Whalebird' $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/whalebird \
      --add-flags $out/opt/Whalebird/resources/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "Electron based Mastodon, Pleroma and Misskey client for Windows, Mac and Linux";
    homepage = "https://whalebird.social";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
