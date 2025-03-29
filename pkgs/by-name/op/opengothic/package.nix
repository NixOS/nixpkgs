{
  alsa-lib,
  cmake,
  fetchFromGitHub,
  glslang,
  lib,
  libX11,
  libXcursor,
  libglvnd,
  makeWrapper,
  ninja,
  nix-update-script,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  vulkan-validation-layers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opengothic";
  version = "1.0.3010";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    tag = "opengothic-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ELDuyoAZmulMjFFctuCmdKDUMtrbVVndJxIf9Xo82N4=";
  };

  outputs = [
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    glslang
    makeWrapper
    ninja
  ];

  buildInputs = [
    alsa-lib
    libX11
    libXcursor
    libglvnd
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "-Werror" ""
  '';

  postFixup = ''
    wrapProgram $out/bin/Gothic2Notr \
      --set LD_PRELOAD "${lib.getLib alsa-lib}/lib/libasound.so.2"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^opengothic-v(.*)$" ];
  };

  meta = {
    description = "Open source re-implementation of Gothic 2: Night of the Raven";
    homepage = "https://github.com/Try/OpenGothic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ azahi ];
    platforms = lib.platforms.linux;
    mainProgram = "Gothic2Notr";
  };
})
