{ lib
, buildGoModule
, fetchurl
}:

buildGoModule rec {
  pname = "libeduvpn-common";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/eduvpn/eduvpn-common/releases/download/${version}/eduvpn-common-${version}.tar.xz";
    hash = "sha256-OgcinEeKMDtZj3Tw+7cMsF385ZZTBR/J5dqIihDTlj8=";
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

  meta = with lib; {
    changelog = "https://raw.githubusercontent.com/eduvpn/eduvpn-common/${version}/CHANGES.md";
    description = "Code to be shared between eduVPN clients";
    homepage = "https://github.com/eduvpn/eduvpn-common";
    maintainers = with maintainers; [ benneti jwijenbergh ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
