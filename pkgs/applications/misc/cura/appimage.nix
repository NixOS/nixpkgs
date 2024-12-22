{
  lib,
  stdenv,
  fetchurl,
  writeScriptBin,
  appimageTools,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  pname = "cura-appimage";
  version = "5.9.0";

  # Give some good names so the intermediate packages are easy
  # to recognise by name in the Nix store.
  appimageBinName = "cura-appimage-tools-output";
  wrapperScriptName = "${pname}-wrapper-script";

  curaAppimageToolsWrapped = appimageTools.wrapType2 {
    # For `appimageTools.wrapType2`, `pname` determines the binary's name in `bin/`.
    pname = appimageBinName;
    inherit version;
    src = fetchurl {
      url = "https://github.com/Ultimaker/Cura/releases/download/${version}/Ultimaker-Cura-${version}-linux-X64.AppImage";
      hash = "sha256-STtVeM4Zs+PVSRO3cI0LxnjRDhOxSlttZF+2RIXnAp4=";
    };
    extraPkgs = _: [ ];
  };

  # The `QT_QPA_PLATFORM=xcb` fixes Wayland support, see
  #     https://github.com/NixOS/nixpkgs/issues/186570#issuecomment-2526277637
  script = writeScriptBin wrapperScriptName ''
    #!${stdenv.shell}
    # AppImage version of Cura loses current working directory and treats all paths relateive to $HOME.
    # So we convert each of the files passed as argument to an absolute path.
    # This fixes use cases like `cd /path/to/my/files; cura mymodel.stl anothermodel.stl`.

    args=()
    for a in "$@"; do
      if [ -e "$a" ]; then
        a="$(realpath "$a")"
      fi
      args+=("$a")
    done
    QT_QPA_PLATFORM=xcb exec "${curaAppimageToolsWrapped}/bin/${appimageBinName}" "''${args[@]}"
  '';
in
stdenv.mkDerivation rec {
  inherit pname version;
  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems ];
  desktopItems = [
    # Based on upstream.
    # https://github.com/Ultimaker/Cura/blob/382b98e8b0c910fdf8b1509557ae8afab38f1817/packaging/AppImage/cura.desktop.jinja
    (makeDesktopItem {
      name = "cura";
      desktopName = "UltiMaker Cura";
      genericName = "3D Printing Software";
      comment = meta.longDescription;
      exec = "cura";
      icon = "cura-icon";
      terminal = false;
      type = "Application";
      mimeTypes = [
        "model/stl"
        "application/vnd.ms-3mfdocument"
        "application/prs.wavefront-obj"
        "image/bmp"
        "image/gif"
        "image/jpeg"
        "image/png"
        "text/x-gcode"
        "application/x-amf"
        "application/x-ply"
        "application/x-ctm"
        "model/vnd.collada+xml"
        "model/gltf-binary"
        "model/gltf+json"
        "model/vnd.collada+xml+zip"
      ];
      categories = [ "Graphics" ];
      keywords = [
        "3D"
        "Printing"
      ];
    })
  ];

  # TODO: Extract cura-icon from AppImage source.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ${script}/bin/${wrapperScriptName} $out/bin/cura

    runHook postInstall
  '';

  meta = {
    description = "3D printing software";
    homepage = "https://github.com/ultimaker/cura";
    longDescription = ''
      Cura converts 3D models into paths for a 3D printer. It prepares your print for maximum accuracy, minimum printing time and good reliability with many extra features that make your print come out great.
    '';
    license = lib.licenses.lgpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      nh2
    ];
  };
}
