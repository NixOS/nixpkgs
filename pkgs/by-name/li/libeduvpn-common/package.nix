{ lib
, buildGoModule
, fetchurl
}:

buildGoModule rec {
  pname = "libeduvpn-common";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/eduvpn/eduvpn-common/releases/download/${version}/eduvpn-common-${version}.tar.xz";
    hash = "sha256-CqpOgvGGD6pW03fvKUzgoeCz6YgnzuYK2u5Zbw+/Ks4=";
  };

  vendorHash = null;

  buildPhase = ''
    runHook preBuild
    go build -o ${pname}-${version}.so -buildmode=c-shared -tags=release ./exports
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib ${pname}-${version}.so
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://raw.githubusercontent.com/eduvpn/eduvpn-common/${version}/CHANGES.md";
    description = "Code to be shared between eduVPN clients";
    homepage = "https://github.com/eduvpn/eduvpn-common";
    maintainers = with maintainers; [ benneti jwijenbergh ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
