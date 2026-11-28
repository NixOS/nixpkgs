{
  pname,
  version,
  src,
  passthru,
  meta,
  lib,
  stdenv,
  appimageTools,
  asar,
  makeWrapper,
  electron,
}:

appimageTools.wrapType2 (finalAttrs: {
  inherit
    pname
    version
    src
    passthru
    ;

  strictDeps = true;

  nativeBuildInputs = [
    asar
    makeWrapper
  ];

  extraInstallCommands = ''
    mkdir -p "$out/opt"
    cp -r --no-preserve=mode "${finalAttrs.contents}/resources" "$out/opt/fastmail"
    asar extract "$out/opt/fastmail/app.asar" "$out/opt/fastmail/app.asar.unpacked"
    rm "$out/opt/fastmail/app.asar"

    install -Dt "$out/share/applications" "${finalAttrs.contents}/fastmail.desktop"
    substituteInPlace "$out/share/applications/fastmail.desktop" \
      --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=fastmail %U" \
      --replace-fail "Name=com.fastmail.Fastmail" "Name=Fastmail"

    for res in 16 24 32 48 64 128 256 512 1024; do
      resdir="''${res}x''${res}"
      install -Dm444 \
        "${finalAttrs.contents}/usr/share/icons/hicolor/$resdir/apps/fastmail.png" \
        "$out/share/icons/hicolor/$resdir/apps/fastmail.png"
    done

    makeWrapper "${electron}/bin/electron" "$out/bin/fastmail" \
      --add-flags "$out/opt/fastmail/app.asar.unpacked" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ (lib.getLib stdenv.cc.cc) ]}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  meta = meta // {
    mainProgram = "fastmail";
  };
})
