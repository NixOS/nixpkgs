{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  libx11,
  libxext,
  pname,
  version,
  meta,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    {
      "x86_64-linux" = fetchurl rec {
        name = "VNC-Viewer-${finalAttrs.version}-Linux-x64.deb";
        url = "https://web.archive.org/web/20251201122208/https://downloads.realvnc.com/download/file/viewer.files/${name}";
        hash = "sha256-BePHXgU1B0kve5o/LXWSWsa13JJJr3OubBrFG8XWqrs=";
      };
    }
    .${stdenv.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];
  buildInputs = [
    libx11
    libxext
    stdenv.cc.cc.libgcc or null
  ];

  postPatch = ''
    substituteInPlace ./usr/share/applications/realvnc-vncviewer.desktop \
      --replace /usr/share/icons/hicolor/48x48/apps/vncviewer48x48.png vncviewer48x48.png
    substituteInPlace ./usr/share/mimelnk/application/realvnc-vncviewer-mime.desktop \
      --replace /usr/share/icons/hicolor/48x48/apps/vncviewer48x48.png vncviewer48x48.png
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out

    runHook postInstall
  '';

  meta = meta // {
    mainProgram = "vncviewer";
  };
})
