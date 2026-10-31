{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
}:
let
  pname = "motrix";
  version = "2.1.1";

  # Upstream publishes one AppImage per architecture, so the source and its hash
  # are selected per host platform and both entries have to be bumped together.
  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/agalwood/Motrix/releases/download/v${version}/Motrix-${version}-x86_64.AppImage";
      hash = "sha256-6d1KzUNvX5USe+1qeXU1f9UTiHYRqIucoLItDNMZsJI=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/agalwood/Motrix/releases/download/v${version}/Motrix-${version}-arm64.AppImage";
      hash = "sha256-i9OtEKP0Xr2iY89W1nVMCVJO60QWJky28SRNFk0Sjoc=";
    };
  };
in
appimageTools.wrapType2 (finalAttrs: {
  inherit pname version;

  src =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "${pname} is not available on ${stdenvNoCC.hostPlatform.system}");

  extraInstallCommands = ''
    install -Dm 444 ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${finalAttrs.pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
  '';

  meta = {
    description = "Full-featured download manager";
    homepage = "https://motrix.app";
    changelog = "https://github.com/agalwood/Motrix/releases/tag/v${version}";
    # The project code is MIT, but the bundled image assets are explicitly not
    # covered by it, see THIRD_PARTY_NOTICES.md in the upstream repository.
    license = lib.licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = [ ];
    mainProgram = "motrix";
  };
})
