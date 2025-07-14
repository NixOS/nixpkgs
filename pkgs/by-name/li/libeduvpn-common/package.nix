{
  lib,
  buildGoModule,
  fetchurl,
}:

buildGoModule rec {
  pname = "libeduvpn-common";
  version = "3.0.0";

  src = fetchurl {
    url = "https://codeberg.org/eduVPN/eduvpn-common/releases/download/${version}/eduvpn-common-${version}.tar.xz";
    hash = "sha256-aQpOoY3rDF9DeQ/8tRYdBs4s2IdwAe62y9KfXPMsb4k=";
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
    changelog = "https://raw.githubusercontent.com/eduvpn/eduvpn-common/${version}/CHANGES.md";
    description = "Code to be shared between eduVPN clients";
    homepage = "https://github.com/eduvpn/eduvpn-common";
    maintainers = with lib.maintainers; [
      benneti
      jwijenbergh
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
