{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "bdf2ttf";
  version = "2.0-unstable-2016-07-03";

  src = fetchFromGitHub {
    owner = "koron";
    repo = "bdf2ttf";
    rev = "1baae7b70a432153e3d876966e47a78f0e572eac";
    hash = "sha256-235BTcTaC/30yLlgo0OO2cp3YCHWa87GFJGBx5lmz6o=";
  };

  dontConfigure = true;

  makeFlags = [ "gcc" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bdf2ttf $out/bin/bdf2ttf
    runHook postInstall
  '';

  meta = {
    description = "Convert BDF font file to TTF (embed bitmap as is, not convert to vector)";
    homepage = "https://github.com/koron/bdf2ttf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
