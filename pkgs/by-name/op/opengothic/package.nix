{
  alsa-lib,
  cmake,
  fetchFromGitHub,
  glslang,
  lib,
  libglvnd,
  libx11,
  libxcursor,
  makeWrapper,
  ninja,
  stdenv,
  vulkan-headers,
  vulkan-loader,
  vulkan-validation-layers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opengothic";
  version = "1.0.3756";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "refs/tags/v0.92";
    fetchSubmodules = true;
    hash = "sha256-6HCBmSjzV3nVDuD/7im6NtWLkDu+V+in2lUloEhp3Cc=";
  };

  nativeBuildInputs = [
    cmake
    glslang
    makeWrapper
    ninja
  ];

  buildInputs = [
    alsa-lib
    libglvnd
    libx11
    libxcursor
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin opengothic/Gothic2Notr

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/Gothic2Notr \
      --prefix LD_PRELOAD : "${lib.getLib alsa-lib}/lib/libasound.so.2"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Open source re-implementation of Gothic 2: Night of the Raven";
    homepage = "https://github.com/Try/OpenGothic";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.linux;
    mainProgram = "Gothic2Notr";
  };
})
