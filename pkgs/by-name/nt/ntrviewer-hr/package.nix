{
  callPackage,
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
  nasm,
  libretro-shaders-slang,
}:
let
  slang_shader_location = "${libretro-shaders-slang}/share/libretro/shaders/shaders_slang";
  version = "0.3.5.6";
  srcs = {
    src = fetchFromGitHub {
      owner = "xzn";
      repo = "ntrviewer-hr";
      tag = "v${version}";
      sha256 = "0ir9q3j84gnbn7fiwmx9mrnhpl82gxplhqni2q7cf6y9i1mqm1wb";
    };

    gitAnime4k = fetchFromGitHub {
      owner = "bloc97";
      repo = "Anime4K";
      rev = "7684e9586f8dcc738af08a1cdceb024cc184f426";
      sha256 = "sha256-F5/n/KmJ7iOiI0qcpwX6q8zvF4ACv6zcJTOxcAv6HSE=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ntrviewer-hr";
  version = "${version}";

  src = srcs.src;

  buildInputs = [
    sdl3
    libplacebo
    librashader
    shaderc
    lcms
    libunwind
    libretro-shaders-slang
  ];

  nativeBuildInputs = [
    vulkan-headers
    pkg-config
    nasm
  ];

  env.NIX_CFLAGS_COMPILE = "-I${librashader}/include/librashader"; # necessary because the librashader package works differently from the other build packages

  doCheck = true;

  installPhase = ''
    runHook preInstall
    ls -la
    mkdir -p $out/bin
    install -m755 ntrviewer $out/bin/ntrviewer
    cp rashader.json $out/bin
    cp placebo.json $out/bin
    mkdir -p $out/bin/placebo-shaders/Anime4K
    cp -R ${srcs.gitAnime4k}/glsl/* "$out/bin/placebo-shaders/Anime4K/"
    mkdir -p $out/bin/slang-shaders
    cp -R ${slang_shader_location}/anti-aliasing $out/bin/slang-shaders/
    cp -R ${slang_shader_location}/edge-smoothing $out/bin/slang-shaders/
    cp -R ${slang_shader_location}/interpolation $out/bin/slang-shaders/
    cp -R ${slang_shader_location}/pixel-art-scaling $out/bin/slang-shaders/
    cp -R ${slang_shader_location}/stock.slang $out/bin/slang-shaders/
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
