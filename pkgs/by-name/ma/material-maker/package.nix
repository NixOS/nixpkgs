{
  lib,
  stdenv,
  fetchFromGitHub,
  godot_4_5,
  vulkan-headers,
  vulkan-loader,
  libx11,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "material-maker";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "RodZill4";
    repo = "material-maker";
    rev = finalAttrs.version;
    hash = "sha256-BnXkEma3J7myF115zMv/VAGtwbbt1asqLUVvRCvrGG8=";
  };

  nativeBuildInputs = [ godot_4_5 ];

  buildInputs = [
    vulkan-headers
    vulkan-loader

    libxinerama
    libxcursor
    libxext
    libxrandr
    libxrender
    libx11
    libxi
    libxfixes
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    mkdir -vp build
    godot4 -v --headless --export-release 'Linux/X11' build/material-maker

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -vp $out/share/material-maker
    cp -vr \
      ./build/* \
      ./addons/material_maker/nodes  \
      ./material_maker/environments  \
      ./material_maker/examples  \
      ./material_maker/library  \
      ./material_maker/meshes  \
      ./material_maker/misc/export \
      $out/share/material-maker

    mkdir -vp $out/bin
    ln -vs $out/share/material-maker/material-maker $out/bin/material-maker

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    patchelf \
      --set-interpreter '${stdenv.cc.bintools.dynamicLinker}' \
      --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs} \
      $out/share/material-maker/material-maker

    runHook postFixup
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Procedural materials authoring tool";
    mainProgram = "material-maker";
    homepage = "https://www.materialmaker.org";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ lelgenio ];
  };
})
