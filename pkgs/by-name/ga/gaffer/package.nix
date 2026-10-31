{
  autoPatchelfHook,
  bash,
  bzip2,
  fetchzip,
  fontconfig,
  glib,
  krb5,
  lcms2,
  lib,
  libGL,
  libGLU,
  libice,
  libsm,
  libtinfo,
  libx11,
  libxcb-image,
  libxcb-cursor,
  libxcb-wm,
  libxcb-keysyms,
  libxcb-render-util,
  libxkbcommon,
  libxt,
  stdenv,
  xz,
  zlib,

  withArnold ? false,
  withRenderman ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gaffer";
  version = "1.6.21.1";
  src = fetchzip {
    url = "https://github.com/GafferHQ/gaffer/releases/download/${finalAttrs.version}/gaffer-${finalAttrs.version}-linux-gcc11.tar.gz";
    hash = "sha256-5F/LTCwRm/zzJfpn21cN6aYl56MJkWGDmVSdMRP99Ec=";
  };
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out/.

    ${lib.optionalString (!withArnold) "rm -r $out/arnold"}
    ${lib.optionalString (!withRenderman) "rm -r $out/renderMan"}

    runHook postInstall
  '';

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  autoPatchelfIgnoreMissingDeps = [
    "*"
  ];

  buildInputs = [
    bash
    bzip2
    fontconfig
    glib
    krb5
    lcms2
    libGL
    libGLU
    libice
    libsm
    libtinfo
    libx11
    libxcb-image
    libxcb-cursor
    libxcb-wm
    libxcb-keysyms
    libxcb-render-util
    libxkbcommon
    libxt
    xz
    zlib
  ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Gaffer is a free, open-source, node-based VFX application.";
    longDescription = ''
      Gaffer is a free, open-source, node-based VFX application that enables look developers, lighters, and compositors to easily build, tweak, iterate, and render scenes.
      Built with flexibility in mind, Gaffer supports in-application scripting in Python and OSL, so VFX artists and technical directors can design shaders,
      automate processes, and build production workflows.

      With hooks in both C++ and Python, Gaffer's readily extensible API provides both professional studios and enthusiasts with the tools to add their own custom modules,
      nodes, and UI.

      The workhorse of the production pipeline at Image Engine Design Inc., Gaffer has been used to build award-winning VFX for shows such as
      Jurassic World: Fallen Kingdom, Lost in Space, Logan, and Game of Thrones.
    '';
    homepage = "https://www.gafferhq.org/";
    changelog = "https://github.com/GafferHQ/gaffer/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    mainProgram = "gaffer";
    maintainers = with lib.maintainers; [ permahorse ];
  };
})
