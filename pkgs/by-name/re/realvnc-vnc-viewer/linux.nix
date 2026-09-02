{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  rpmextract,
  buildFHSEnv,
  libx11,
  libxext,
  libepoxy,
  fontconfig,
  glib,
  gtk3,
  xdg-utils,
  shared-mime-info,
  desktop-file-utils,
  pname,
  version,
  meta,
}:

let
  vncviewer-unwrapped = stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src =
      {
        "x86_64-linux" = fetchurl rec {
          name = "RealVNC-Connect-Viewer-${finalAttrs.version}-Linux-x64.rpm";
          url = "https://downloads.realvnc.com/download/file/realvnc-connect-viewer/${name}";
          hash = "sha256-x/NG9ivYUbtrFxksglCLF+lGA2OO2VdEN1qPsvum7tQ=";
        };
      }
      .${stdenv.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    nativeBuildInputs = [
      autoPatchelfHook
      rpmextract
    ];
    buildInputs = [
      libx11
      libxext
      libepoxy
      fontconfig
      glib
      gtk3
      stdenv.cc.cc.libgcc or null
    ];

    unpackPhase = ''
      rpmextract $src
    '';

    installPhase = ''
      runHook preInstall

      mv usr $out
      find $out -xtype l -delete

      runHook postInstall
    '';
  });
in
buildFHSEnv {
  # buildFHSEnv needed because the newer version uses a tricky hardcoded external binary path:
  # /usr/bin/xdg-mime. Otherwise a crash will take place when openning browser or signing in
  inherit pname version meta;

  runScript = "${vncviewer-unwrapped}/lib/rvncconnect/rvncconnect";

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons
    cp -r ${vncviewer-unwrapped}/share/applications/. $out/share/applications/
    cp -r ${vncviewer-unwrapped}/share/icons/. $out/share/icons/

    substituteInPlace $out/share/applications/com.realvnc.rvncconnect.desktop \
      --replace-fail /usr/lib/rvncconnect/rvncconnect $out/bin/realvnc-vnc-viewer \
      --replace-fail /usr/share/icons/hicolor/scalable/apps/com.realvnc.rvncconnect.svg $out/share/icons/hicolor/scalable/apps/com.realvnc.rvncconnect.svg
    substituteInPlace $out/share/applications/com.realvnc.rvncconnect.connect.uri.desktop \
      --replace-fail /usr/lib/rvncconnect/rvncconnect $out/bin/realvnc-vnc-viewer
  '';

  targetPkgs = pkgs: [
    vncviewer-unwrapped
    xdg-utils
    shared-mime-info
    desktop-file-utils
  ];
}
