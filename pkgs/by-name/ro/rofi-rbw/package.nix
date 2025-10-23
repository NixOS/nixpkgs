{
  lib,
  python3Packages,
  fetchFromGitHub,
  rbw,

  waylandSupport ? false,
  wl-clipboard,
  wtype,

  x11Support ? false,
  xclip,
  xdotool,
}:

python3Packages.buildPythonApplication rec {
  pname = "rofi-rbw";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fdw";
    repo = "rofi-rbw";
    tag = version;
    hash = "sha256-Qdbz3UjWMCuJUzR6UMt/apt+OjMAr2U7uMtv9wxEZKE=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = [
    python3Packages.configargparse
  ];

  pythonImportsCheck = [ "rofi_rbw" ];

  preFixup =
    let
      wrapperPaths = [
        rbw
      ]
      ++ lib.optionals waylandSupport [
        wl-clipboard
        wtype
      ]
      ++ lib.optionals x11Support [
        xclip
        xdotool
      ];

      wrapperFlags =
        lib.optionalString waylandSupport " --typer wtype --clipboarder wl-copy"
        + lib.optionalString x11Support " --typer xdotool --clipboarder xclip";
    in
    ''
      makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath wrapperPaths} --add-flags "${wrapperFlags}")
    '';

  meta = {
    description = "Rofi frontend for Bitwarden";
    homepage = "https://github.com/fdw/rofi-rbw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      equirosa
      dit7ya
    ];
    platforms = lib.platforms.linux;
    mainProgram = "rofi-rbw";
  };
}
