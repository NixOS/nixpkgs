{
  lib,
  buildGoModule,
  fetchFromCodeberg,
}:

buildGoModule (finalAttrs: {
  pname = "libeduvpn-common";
  version = "5.0.4";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "eduVPN";
    repo = "eduvpn-common";
    tag = finalAttrs.version;
    hash = "sha256-00Zr5WLm6tagwh0frW+wPthNGdTkwmFo3ebyf0syKfo=";
  };

  vendorHash = "sha256-IlvVaTGHrTBu5Oq1fGDwDpKuQHOHxSXj++2fDed3NSU=";

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
