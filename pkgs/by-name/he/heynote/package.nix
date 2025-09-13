{
  appimageTools,
  desktop-file-utils,
  fetchurl,
  lib,
  nix-update-script,
}:
let
  pname = "heynote";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/heyman/heynote/releases/download/v${version}/Heynote_${version}_x86_64.AppImage";
    sha256 = "sha256-01GWQxauMKwqEp3kbegCwn2lpsobtRjO+6I90wiH9wU=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit version pname src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ desktop-file-utils ];

  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps $out/share/licenses/heynote
    cp ${appimageContents}/heynote.png $out/share/pixmaps/
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
