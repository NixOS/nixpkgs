{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:

buildGoModule (finalAttrs: {
  pname = "libeduvpn-common";
  version = "5.0.3";

  src = fetchFromCodeberg {
    owner = "eduVPN";
    repo = "eduvpn-common";
    tag = finalAttrs.version;
    hash = "sha256-tJT0+ZCtiHOcWFBsIFuVocwGTDaj7fCK8B5eu+J1Y50=";
  };

  vendorHash = "sha256-FoYK6f7AvkYf8PjI2JK0Jld/nFQ4Q5fulepqEhw3B4g=";

  buildPhase = ''
    runHook preBuild
    go build -o libeduvpn-common-${finalAttrs.version}.so -buildmode=c-shared ./exports
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
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
