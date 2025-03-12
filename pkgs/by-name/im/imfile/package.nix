{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, electron_30
}:
let
  pname = "imfile";
  version = "1.1.0";

  buildUrl = arch: "https://github.com/imfile-io/imfile-desktop/releases/download/v${version}/imFile_${version}_${arch}.deb";

  srcs = {
    x86_64-linux = fetchurl {
      url = buildUrl "amd64";
      hash = "sha256-ZNbw0fobzY/AfmxDItSsocOoQy9i0ZQ8jjMcrKMUPvQ=";
    };

    aarch64-linux = fetchurl {
      url = buildUrl "arm64";
      hash = "sha256-7mvibLdUrzYZV7r8fv0zwKJHs61nk+6lW1GYFELdwVU=";
    };

    armv7l-linux = fetchurl {
      url = buildUrl "armv7l";
      hash = "sha256-vYU0kBIWcJ4yfZf7B4hcB43/fObOgGva5RrHO3GRnyo=";
    };
  };

  src = srcs.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt/imFile
    cp -r opt/imFile/{resources,locales} $out/opt/imFile
    cp -r usr/share $out/share

    substituteInPlace $out/share/applications/imfile.desktop \
      --replace-fail "/opt/imFile/imfile" "$out/bin/imfile"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_30}/bin/electron $out/bin/imfile \
      --add-flags $out/opt/imFile/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --set-default ELECTRON_IS_DEV 0
  '';

  meta = with lib; {
    description = "A full-featured download manager";
    homepage = "https://imfile.io";
    changelog = "https://github.com/imfile-io/imfile-desktop/releases/tag/v${version}";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    mainProgram = "imfile";
    maintainers = with maintainers; [ Zh40Le1ZOOB ];
  };
}
