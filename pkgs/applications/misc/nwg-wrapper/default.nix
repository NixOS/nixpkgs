{ lib, python3Packages, fetchFromGitHub, gtk-layer-shell, gtk3, gobject-introspection, wrapGAppsHook, wlr-randr }:

python3Packages.buildPythonPackage rec {
  pname = "nwg-wrapper";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LkAB0MrwQxP3X7glfSnI0GZMv8tjaeSOz7WSOW33wuo=";
  };

  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];

  buildInputs = [ gtk3 gtk-layer-shell ];

  propagatedBuildInputs = with python3Packages; [ i3ipc pygobject3 ];

  # ValueError: Namespace GtkLayerShell not available
  strictDeps = false;

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
    homepage = "https://github.com/nwg-piotr/nwg-wrapper/";
    license = licenses.mit;
    maintainers = with maintainers; [ artturin ];
  };
}
