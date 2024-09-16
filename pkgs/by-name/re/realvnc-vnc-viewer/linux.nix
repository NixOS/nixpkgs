{ stdenv
, fetchurl
, autoPatchelfHook
, rpmextract
, libX11
, libXext
, pname
, version
, meta
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = {
    "x86_64-linux" = fetchurl rec {
      name = "VNC-Viewer-${finalAttrs.version}-Linux-x64.rpm";
      url = "https://downloads.realvnc.com/download/file/viewer.files/${name}";
      hash = "sha256-KJZbH3mfxuyUslkYvB/RKquEsB7ayJSv6yNqfLmAsGI=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [ autoPatchelfHook rpmextract ];
  buildInputs = [ libX11 libXext stdenv.cc.cc.libgcc or null ];

  unpackPhase = ''
    rpmextract $src
  '';

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

  meta = meta // { mainProgram = "vncviewer"; };
})
