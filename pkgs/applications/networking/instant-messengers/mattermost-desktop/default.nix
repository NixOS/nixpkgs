{ lib
, stdenv
, fetchurl
, atomEnv
, systemd
, pulseaudio
, libxshmfence
, libnotify
, libappindicator-gtk3
, wrapGAppsHook
, autoPatchelfHook
}:

let

  pname = "mattermost-desktop";
<<<<<<< HEAD
  version = "5.3.1";
=======
  version = "5.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  srcs = {
    "x86_64-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-x64.tar.gz";
<<<<<<< HEAD
      hash = "sha256-rw+SYCFmN2W4t5iIWEpV9VHxcvwTLOckMV58WRa5dZE=";
    };

    "aarch64-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-arm64.tar.gz";
      hash = "sha256-FEIldkb3FbUfVAYRkjs7oPRJDHdsIGDW5iaC2Qz1dpc=";
=======
      hash = "sha256-KmtQUqg2ODbZ6zJjsnwlvB+vhR1xbK2X9qqmZpyTR78=";
    };

    "i686-linux" = {
      url = "https://releases.mattermost.com/desktop/${version}/${pname}-${version}-linux-ia32.tar.gz";
      hash = "sha256-X8Zrthw1hZOqmcYidt72l2vonh31iiA3EDGmCQr7e4c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  inherit (stdenv.hostPlatform) system;

in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl (srcs."${system}" or (throw "Unsupported system ${system}"));

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;

  nativeBuildInputs = [ wrapGAppsHook autoPatchelfHook ];

  buildInputs = atomEnv.packages ++ [
    libxshmfence
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
    pulseaudio
    libnotify
    libappindicator-gtk3
  ];

  installPhase = ''
    runHook preInstall

    # Mattermost tarball comes with executable bit set for everything.
    # We’ll apply it only to files that need it.
    find . -type f -print0 | xargs -0 chmod -x
    find . -type f \( -name '*.so.*' -o -name '*.s[oh]' \) -print0 | xargs -0 chmod +x
    chmod +x mattermost-desktop chrome-sandbox

    mkdir -p $out/share/mattermost-desktop
    cp -R . $out/share/mattermost-desktop

    mkdir -p "$out/bin"
    ln -s $out/share/mattermost-desktop/mattermost-desktop $out/bin/mattermost-desktop

    patchShebangs $out/share/mattermost-desktop/create_desktop_file.sh
    $out/share/mattermost-desktop/create_desktop_file.sh
    rm $out/share/mattermost-desktop/create_desktop_file.sh
    mkdir -p $out/share/applications
    chmod -x Mattermost.desktop
    mv Mattermost.desktop $out/share/applications/Mattermost.desktop
    substituteInPlace $out/share/applications/Mattermost.desktop \
      --replace /share/mattermost-desktop/mattermost-desktop /bin/mattermost-desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Mattermost Desktop client";
    homepage = "https://about.mattermost.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
<<<<<<< HEAD
    platforms = [ "x86_64-linux" "aarch64-linux" ];
=======
    platforms = [ "x86_64-linux" "i686-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.joko ];
  };
}
