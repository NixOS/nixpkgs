{
  appimageTools,
  lib,
  fetchurl,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "nuclear";
  version = "0.6.48";
  src = fetchurl {
    # Nuclear currently only publishes AppImage releases for x86_64, which is hardcoded in
    # the package name. We also hardcode the host arch in the release name, but should upstream
    # provide more arches, we should use stdenv.hostPlatform to determine the arch and choose
    # source URL accordingly.
    url = "https://github.com/nukeop/nuclear/releases/download/v${finalAttrs.version}/${finalAttrs.pname}-v${finalAttrs.version}-x86_64.AppImage";
    hash = "sha256-k3qGWPn+O4kazsrrZAYHIvSrrix9LNnnJgZGJqlJbJE=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Streaming music player that finds free music for you";
    homepage = "https://nuclear.js.org/";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.NotAShelf ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "nuclear";
  };
})
