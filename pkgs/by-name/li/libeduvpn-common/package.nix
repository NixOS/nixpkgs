{
  lib,
  buildGoModule,
  fetchurl,
}:

buildGoModule rec {
  pname = "libeduvpn-common";
  version = "4.0.0";

  src = fetchurl {
    url = "https://codeberg.org/eduVPN/eduvpn-common/releases/download/${version}/eduvpn-common-${version}.tar.xz";
    hash = "sha256-pMxcHiX6Ct6QpU13JnoEyqt7bd58dmOxoncIp6PDvgo=";
  };

  vendorHash = null;

  buildPhase = ''
    runHook preBuild
    go build -o libeduvpn-common-${version}.so -buildmode=c-shared -tags=release ./exports
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib libeduvpn-common-${version}.so
    runHook postInstall
  '';

  meta = {
    changelog = "https://codeberg.org/eduVPN/eduvpn-common/raw/tag/${version}/CHANGES.md";
    description = "Code to be shared between eduVPN clients";
    homepage = "https://codeberg.org/eduVPN/eduvpn-common";
    maintainers = with lib.maintainers; [
      benneti
      jwijenbergh
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
