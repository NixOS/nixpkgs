{
  lib,
  python3Packages,
  fetchFromGitHub,
  gtk-layer-shell,
  gtk3,
  gobject-introspection,
  wrapGAppsHook3,
  wlr-randr,
}:

python3Packages.buildPythonPackage rec {
  pname = "nwg-wrapper";
  version = "0.1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-wrapper";
    tag = "v${version}";
    sha256 = "sha256-GKDAdjO67aedCEFHKDukQ+oPMomTPwFE/CvJu112fus=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtk-layer-shell
  ];

  propagatedBuildInputs = with python3Packages; [
    i3ipc
    pygobject3
  ];

  # No tests
  doCheck = false;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${lib.makeBinPath [ wlr-randr ]}"
    )
  '';

  pythonImportsCheck = [ "nwg_wrapper" ];

  meta = with lib; {
    description = "Wrapper to display a script output or a text file content on the desktop in sway or other wlroots-based compositors";
    mainProgram = "nwg-wrapper";
    homepage = "https://github.com/nwg-piotr/nwg-wrapper/";
    license = licenses.mit;
    maintainers = with maintainers; [ artturin ];
  };
}
