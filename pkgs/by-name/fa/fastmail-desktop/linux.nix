{
  lib,
  pname,
  version,
  src,
  passthru,
  meta,
  stdenv,
  stdenvNoCC,
  appimageTools,
  asar,
  makeWrapper,
  electron,
}:
let
  appimageContents = appimageTools.extract { inherit pname version src; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version passthru;

  dontUnpack = true;
  dontBuild = true;

  strictDeps = true;

  nativeBuildInputs = [
    asar
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt"
    cp -r --no-preserve=mode "${appimageContents}/resources" "$out/opt/fastmail"
    asar extract "$out/opt/fastmail/app.asar" "$out/opt/fastmail/app.asar.unpacked"
    rm "$out/opt/fastmail/app.asar"

    install -Dt "$out/share/applications" "${appimageContents}/fastmail.desktop"
    substituteInPlace "$out/share/applications/fastmail.desktop" \
      --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=fastmail %U" \
      --replace-fail "Name=com.fastmail.Fastmail" "Name=Fastmail"

    for res in 16 24 32 48 64 128 256 512 1024; do
      resdir="''${res}x''${res}"
      mkdir -p "$out/share/icons/hicolor/$resdir/apps"
      cp -r --no-preserve=mode \
        "${appimageContents}/usr/share/icons/hicolor/$resdir/apps/fastmail.png" \
        "$out/share/icons/hicolor/$resdir/apps/fastmail.png"
    done

    # The bundled sharp libraries need libstdc++, which electron neither links
    # nor exposes to dlopen: its libstdc++ directory is listed in DT_RUNPATH,
    # and the loader does not consult a RUNPATH when resolving the
    # dependencies of a dlopen'd object.  It has to be supplied through
    # LD_LIBRARY_PATH rather than by rewriting the libraries with patchelf,
    # because patchelf corrupts libvips-cpp: its _init routine lives at file
    # offset 0x25c, inside the region patchelf overwrites when it relocates
    # the string table, and the rewritten library segfaults on load.
    makeWrapper "${electron}/bin/electron" "$out/bin/fastmail" \
      --add-flags "$out/opt/fastmail/app.asar.unpacked" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ (lib.getLib stdenv.cc.cc) ]}" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  meta = meta // {
    mainProgram = "fastmail";
  };
})
