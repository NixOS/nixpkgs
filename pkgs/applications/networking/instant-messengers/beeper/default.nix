{ lib
, stdenvNoCC
, fetchurl
, appimageTools
, libsecret
, makeWrapper
, writeShellApplication
, curl
, yq
, common-updater-scripts
}:
let
  pname = "beeper";
  version = "3.93.36";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://download.todesktop.com/2003241lzgn20jd/beeper-3.93.36-build-2401269p8vcb695-x86_64.AppImage";
    hash = "sha256-3pOOAI4/BWdbWfPweRx5I2KRi9VOgJ5vcQ89FTJhPak=";
  };
  appimage = appimageTools.wrapType2 {
    inherit version pname src;
    extraPkgs = pkgs: with pkgs; [ libsecret ];
  };
  appimageContents = appimageTools.extractType2 {
    inherit version pname src;
  };
in
stdenvNoCC.mkDerivation rec {
  inherit name pname version;

  src = appimage;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mv bin/${name} bin/${pname}

    mkdir -p $out/
    cp -r bin $out/bin

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/locales $out/share/${pname}
    cp -a ${appimageContents}/resources $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 644 ${appimageContents}/${pname}.desktop -t $out/share/applications/

    substituteInPlace $out/share/applications/${pname}.desktop --replace "AppRun" "${pname}"

    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}} --no-update"

    runHook postInstall
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-beeper";
      runtimeInputs = [ curl yq common-updater-scripts ];
      text = ''
        set -o errexit
        latestLinux="$(curl -s https://download.todesktop.com/2003241lzgn20jd/latest-linux.yml)"
        version="$(echo "$latestLinux" | yq -r .version)"
        filename="$(echo "$latestLinux" | yq -r '.files[] | .url | select(. | endswith(".AppImage"))')"
        update-source-version beeper "$version" "" "https://download.todesktop.com/2003241lzgn20jd/$filename" --source-key=src.src
      '';
    });
  };

  meta = with lib; {
    description = "Universal chat app.";
    longDescription = ''
      Beeper is a universal chat app. With Beeper, you can send
      and receive messages to friends, family and colleagues on
      many different chat networks.
    '';
    homepage = "https://beeper.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ jshcmpbll mjm edmundmiller ];
    platforms = [ "x86_64-linux" ];
  };
}
