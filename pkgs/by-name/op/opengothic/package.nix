{
  alsa-lib,
  cmake,
  fetchFromGitHub,
  glslang,
  lib,
  libx11,
  libxcursor,
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
  version = "1.0.3549";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    tag = "opengothic-v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-dXKZPfV434HHVPgulZZEKhypR6q+uACgmoNWvNQv92w=";
  };

  nativeBuildInputs = [
    cmake
    glslang
    makeWrapper
    ninja
  ];

  buildInputs = [
    alsa-lib
    libx11
    libxcursor
    libglvnd
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "-Werror" ""
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin opengothic/Gothic2Notr
    install -Dm755 -t $out/lib opengothic/libTempest.so

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/Gothic2Notr \
      --prefix LD_PRELOAD : "${lib.getLib alsa-lib}/lib/libasound.so.2"
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
