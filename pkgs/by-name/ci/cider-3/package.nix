{
  appimageTools,
  dbus,
  lib,
  stdenv,
  stdenvNoCC,
  requireFile,
  makeWrapper,
  undmg,
}:
let
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x64";
  platform = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  ext = if stdenv.hostPlatform.isDarwin then "dmg" else "AppImage";
  mkCider = if stdenv.hostPlatform.isDarwin then stdenv.mkDerivation else appimageTools.wrapType2;
in
mkCider rec {
  pname = "cider-3";
  version = "3.0.2";

  src = requireFile {
    name = "cider-v${version}-${platform}-${arch}.${ext}";
    sha256 =
      {
        aarch64-darwin = "0mg593wc49hng6r3c24ydws9k7ysg8zp1hiwzrckqx1c516cw0d0";
        x86_64-darwin = "1d559zwzv1f6xlq1v3f2ss7g3vshks837ianh81cl0w35q1hyy97";
        x86_64-linux = "1rfraf1r1zmp163kn8qg833qxrxmx1m1hycw8q9hc94d0hr62l2x";
      }
      .${stdenv.hostPlatform.system};

    url = "https://taproom.cider.sh/downloads";
  };

  sourceRoot = lib.optionalString stdenv.hostPlatform.isDarwin "Cider.app";
  nativeBuildInputs = if stdenv.hostPlatform.isDarwin then [ undmg ] else [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract {
        inherit version src;
        # HACK: this looks for a ${pname}.desktop, where `cider-3.desktop` doesn't exist
        pname = "Cider";
      };
    in
    lib.optionalDrvAttr (!stdenv.hostPlatform.isDarwin) ''
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags "--no-sandbox --disable-gpu-sandbox" # Cider 2 does not start up properly without these from my preliminary testing

      install -Dm444 ${contents}/Cider.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-warn 'Exec=Cider' 'Exec='$out'/bin/${pname}' \
        --replace-warn 'Exec=dbus-send' 'Exec=${lib.getExe' dbus "dbus-send"}'
      install -Dm444 ${contents}/usr/share/icons/hicolor/256x256/cider.png \
                    $out/share/icons/hicolor/256x256/apps/cider.png
    '';

  installPhase =
    let
      appPath = "$out/Applications/Cider.app";
    in
    lib.optionalDrvAttr stdenv.hostPlatform.isDarwin ''
      runHook preInstall

      mkdir -p $out/bin ${appPath}
      cp -r Contents ${appPath}/

      cat > $out/bin/${pname} << EOF
      #!${stdenvNoCC.shell}
      open -na ${appPath} --args "\$@"
      EOF
      chmod +x $out/bin/${pname}

      runHook postInstall
    '';

  meta = {
    description = "Powerful music player that allows you listen to your favorite tracks with style";
    homepage = "https://cider.sh";
    license = lib.licenses.unfree;
    mainProgram = "cider-3";
    maintainers = with lib.maintainers; [
      itsvic-dev
      l0r3v
      ejstrunz
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
