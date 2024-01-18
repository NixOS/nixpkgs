{ lib
, stdenv
, fetchurl
, electron_26
, makeWrapper
}:

let

  pname = "mattermost-desktop";
  version = "5.5.1";

  srcs = {
    "x86_64-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-x64.tar.gz";
      hash = "sha256-bRiO5gYM7nrnkbHBP3B9zAK2YV5POkc3stEsbZJ48VA=";
    };

    "aarch64-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-arm64.tar.gz";
      hash = "sha256-Z4U6Jbwasra69QPHJ9/7WwMSxh0O9r4QIe/xC3WRf4w=";
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

    makeWrapper ${electron_26}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/app.asar

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mattermost Desktop client";
    homepage = "https://about.mattermost.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = [ maintainers.joko ];
  };
}
