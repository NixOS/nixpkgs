{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  makeWrapper,
  gpu-screen-recorder,
  gpu-screen-recorder-notification,
  libX11,
  libXrender,
  libXrandr,
  libXcomposite,
  libXi,
  libglvnd,
  wrapperDir ? "/run/wrappers/bin",
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-ui";
  version = "1.0.0";

  src = fetchurl {
    url = "https://dec05eba.com/snapshot/${pname}.git.${version}.tar.gz";
    hash = "sha256-2gB6FWys5RGDlwc1OZ0NnjU8eIGJefpjc94YKJSnyPI=";
  };

  sourceRoot = ".";

  postPatch = ''
    substituteInPlace depends/mglpp/depends/mgl/src/gl.c \
      --replace-fail "libGL.so.1" "${lib.getLib libglvnd}/lib/libGL.so.1" \
      --replace-fail "libGLX.so.0" "${lib.getLib libglvnd}/lib/libGLX.so.0" \
      --replace-fail "libEGL.so.1" "${lib.getLib libglvnd}/lib/libEGL.so.1"

    substituteInPlace extra/gpu-screen-recorder-ui.service \
      --replace-fail "ExecStart=${meta.mainProgram}" "ExecStart=$out/bin/${meta.mainProgram}"
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    makeWrapper
  ];

  buildInputs = [
    libX11
    libXrender
    libXrandr
    libXcomposite
    libXi
    libglvnd
  ];

  mesonFlags = [
    # Handled by the module
    (lib.mesonBool "capabilities" false)
  ];

  postInstall =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram "$out/bin/${meta.mainProgram}" \
        --prefix PATH : "${wrapperDir}" \
        --suffix PATH : "${
          lib.makeBinPath [
            gpu-screen-recorder-wrapped
            gpu-screen-recorder-notification
          ]
        }"
    '';

  passthru.updateScript = gitUpdater { url = "https://repo.dec05eba.com/${pname}"; };

  meta = {
    description = "A fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/${pname}/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-ui";
    maintainers = with lib.maintainers; [ js6pak ];
    platforms = lib.platforms.linux;
  };
}
