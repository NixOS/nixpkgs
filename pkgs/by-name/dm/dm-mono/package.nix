{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "dm-mono";
  version = "0.0";

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
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ jennifgcrl ];
  };
}
