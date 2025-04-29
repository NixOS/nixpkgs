{
  stdenv,
  lib,
  fetchhg,
  libepoxy,
  xorg,
  libGLU,
  glm,
  pkg-config,
  imagemagick,
  makeWrapper,
  installShellFiles,
  genericUpdater,
  writeShellScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shadershark";
  version = "0.1";

  src = fetchhg {
    url = "https://hg.globalcode.info/graphics/shader-shark";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AYZWfqMckPKgXNIX9kAAv1mvD3opLi5EUElFsigiF3c=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    libepoxy
    xorg.libX11
    libGLU
    glm
    imagemagick
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/shadershark}

    install -m755 -D build/shader-shark $out/bin
    cp -r shaders textures $out/share/shadershark

    wrapProgram $out/bin/shader-shark \
      --set SHADER_SHARK_DATA_DIR $out/share/shadershark

    installShellCompletion --bash --name shader-shark.bash bash-completion.sh

    runHook postInstall
  '';

  passthru.updateScript = genericUpdater {
    inherit (finalAttrs) pname version;
    versionLister = writeShellScript "shadershark-tags" ''
      repo_url=${finalAttrs.src.url}
      curl "$repo_url/tags" | grep '/rev/v' | sed 's;.*/rev/v\([^"]*\)[^$]*;\1; #'
    '';
  };

  meta = with lib; {
    mainProgram = "shader-shark";
    description = "OpenGL/X11 application for GNU/Linux consisting of a single window that shows simple 3D scene of a textured rectangle with applied vertex and fragment shaders (GLSL)";
    homepage = "https://graphics.globalcode.info/v_0/shader-shark.xhtml";
    license = licenses.gpl3;
    maintainers = [ maintainers.lucasew ];
    platforms = platforms.linux;
  };
})
