{
  lib,
  buildGoModule,
  fetchurl,
}:

buildGoModule (finalAttrs: {
  pname = "libeduvpn-common";
  version = "5.0.1";

  src = fetchurl {
    url = "https://codeberg.org/eduVPN/eduvpn-common/releases/download/${finalAttrs.version}/eduvpn-common-${finalAttrs.version}.tar.xz";
    hash = "sha256-W5f+qvFEVu4+swhTwceMKxZt5UHY+O4dt+oNDM/IEsM=";
  };

  vendorHash = null;

  buildPhase = ''
    runHook preBuild
    go build -o libeduvpn-common-${finalAttrs.version}.so -buildmode=c-shared -tags=release ./exports
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib libeduvpn-common-${finalAttrs.version}.so
    runHook postInstall
  '';

  meta = {
    changelog = "https://codeberg.org/eduVPN/eduvpn-common/raw/tag/${finalAttrs.version}/CHANGES.md";
    description = "Code to be shared between eduVPN clients";
    homepage = "https://codeberg.org/eduVPN/eduvpn-common";
    maintainers = with lib.maintainers; [
      benneti
      jwijenbergh
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
