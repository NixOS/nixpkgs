{ callPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  nixos,
  testers,
  versionCheckHook,
  sdl3,
  pkg-config,
  vulkan-headers,
  libplacebo,
  librashader,
  lcms,
  libunwind,
  shaderc,
  nasm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntrviewer-hr";
  version = "0.3.5.6";

  src = fetchFromGitHub {
    owner = "xzn";
    repo = "ntrviewer-hr";
    tag = "v${finalAttrs.version}";
    sha256 = "0ir9q3j84gnbn7fiwmx9mrnhpl82gxplhqni2q7cf6y9i1mqm1wb";
  };

  buildInputs = [
    sdl3
    libplacebo
    vulkan-headers
  ];

  nativeBuildInputs = [
    librashader
    pkg-config
    lcms
    libunwind
    shaderc
    nasm
  ];

  env.NIX_CFLAGS_COMPILE = "-I${librashader}/include/librashader"; # necessary because the librashader package works differently from the other build packages

  doCheck = true;

  installPhase = ''
    runHook preInstall
    ls -la
    mkdir -p $out/bin
    install -m755 ntrviewer $out/bin/ntrviewer
    runHook postInstall
  '';

  meta = {
    description = "Viewer for wireless screen casting from New 3DS/New 2DS to PC (Windows/Linux/macOS)";
    homepage = "https://github.com/xzn/ntrviewer-hr";
    changelog = "https://github.com/xzn/ntrviewer-hr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alejoheu ];
    mainProgram = "ntrviewer";
    platforms = lib.platforms.all;
  };
})
