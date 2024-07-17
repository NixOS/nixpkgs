{
  lib,
  stdenv,
  fetchurl,
  electron,
  makeWrapper,
}:

let

  pname = "mattermost-desktop";
  version = "5.8.1";

  srcs = {
    "x86_64-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-x64.tar.gz";
      hash = "sha256-VuYHF5ALdbsKxBI7w5UhcqKYLV8BHZncWSDeuCy/SW0=";
    };

    "aarch64-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-arm64.tar.gz";
      hash = "sha256-b+sVzMX/NDavshR+WsQyVgYyLkIPSuUlZGqK6/ZjLFs=";
    };
  };

  inherit (stdenv.hostPlatform) system;

in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl (srcs."${system}" or (throw "Unsupported system ${system}"));

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    # Mattermost tarball comes with executable bit set for everything.
    # We’ll apply it only to files that need it.
    find . -type f -print0 | xargs -0 chmod -x
    find . -type f \( -name '*.so.*' -o -name '*.s[oh]' \) -print0 | xargs -0 chmod +x
    chmod +x mattermost-desktop chrome-sandbox

    mkdir -p $out/bin $out/share/applications $out/share/${pname}/
    cp -r app_icon.png create_desktop_file.sh locales/ resources/* $out/share/${pname}/

    patchShebangs $out/share/${pname}/create_desktop_file.sh
    $out/share/${pname}/create_desktop_file.sh
    rm $out/share/${pname}/create_desktop_file.sh
    mv Mattermost.desktop $out/share/applications/Mattermost.desktop
    substituteInPlace $out/share/applications/Mattermost.desktop \
      --replace /share/mattermost-desktop/mattermost-desktop /bin/mattermost-desktop

    makeWrapper '${lib.getExe electron}' $out/bin/${pname} \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags $out/share/${pname}/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mattermost Desktop client";
    mainProgram = "mattermost-desktop";
    homepage = "https://about.mattermost.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ maintainers.joko ];
  };
}
