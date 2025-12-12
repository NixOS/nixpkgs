{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "dm-mono";
  version = "1.0-unstable-2020-04-15";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "dm-mono";
    rev = "57fadabfb200a77de2812540026c249dc3013077";
    hash = "sha256-Xj6UmvH7tqW6xdobBxuafqc7TB1nrTFwHWv4DaZmwx8=";
  };

  installPhase = ''
    runHook preInstall

    install -m644 --target $out/share/fonts/truetype -D exports/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "Monospace typeface";
    homepage = "https://github.com/googlefonts/dm-mono";
    changelog = "https://github.com/googlefonts/dm-mono/blob/main/CHANGELOG.md";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ jennifgcrl ];
  };
}
