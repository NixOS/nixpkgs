{
  appimageTools,
  desktop-file-utils,
  fetchurl,
  lib,
  nix-update-script,
}:
let
  pname = "heynote";
  version = "2.9.0";

  src = fetchurl {
    url = "https://github.com/heyman/heynote/releases/download/v${version}/Heynote_${version}_x86_64.AppImage";
    sha256 = "sha256-5SCIMvhpFUwpcZaxUwDjWRN05QFLgKKE1C2J32lapH8=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit version pname src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ desktop-file-utils ];

  extraInstallCommands = ''
    mkdir -p $out/share/licenses/heynote
    install -D ${appimageContents}/heynote.png -t $out/share/icons/hicolor/512x512/apps
    cp ${appimageContents}/heynote.desktop $out
    # verify binary is present
    stat $out/bin/heynote
    desktop-file-install --dir $out/share/applications \
    --set-key Exec --set-value heynote \
    --set-key Comment --set-value "Heynote" \
    --delete-original $out/heynote.desktop
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "heynote";
    description = "Dedicated scratchpad for developers";
    homepage = "https://heynote.com/";
    changelog = "https://github.com/heyman/heynote/releases/v${version}";
    license = with lib.licenses; [
      mit
      commons-clause
    ];
    maintainers = with lib.maintainers; [ jasoncrevier ];
    platforms = lib.platforms.x86_64;
  };
}
