{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  nix-update-script,
  commandLineArgs ? "",
}:

let
  pname = "anytype";
  version = "0.44.0";
  name = "Anytype-${version}";
  src = fetchurl {
    url = "https://github.com/anyproto/anytype-ts/releases/download/v${version}/${name}.AppImage";
    hash = "sha256-+Ae0xH6ipNZgIVrrAmgeG8bibm/I3NLiDMzS+fwf9RQ=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
    install -m 444 -D ${appimageContents}/anytype.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/anytype.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    for size in 16 32 64 128 256 512 1024; do
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/''${size}x''${size}/apps/anytype.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/anytype.png
    done
  '';

  passthru.updateScript = nix-update-script {
    # Prevent updating to versions with '-' in them.
    # Necessary since Anytype uses Electron-based 'MAJOR.MINOR.PATCH(-{alpha,beta})?' versioning scheme where each
    #  {alpha,beta} version increases the PATCH version, releasing a new full release version in GitHub instead of a
    #  pre-release version.
    extraArgs = [
      "--version-regex"
      "[^-]*"
    ];
  };

  meta = with lib; {
    description = "P2P note-taking tool";
    homepage = "https://anytype.io/";
    license = licenses.unfree;
    mainProgram = "anytype";
    maintainers = with maintainers; [ running-grass ];
    platforms = [ "x86_64-linux" ];
  };
}
