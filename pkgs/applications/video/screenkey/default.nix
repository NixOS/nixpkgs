{ lib
, fetchFromGitLab
, wrapGAppsHook
, xorg
, gobject-introspection
, gtk3
, libappindicator-gtk3
, slop
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "screenkey";
  version = "1.5";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kWktKzRyWHGd1lmdKhPwrJoSzAIN2E5TKyg30uhM4Ug=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    # for setup hook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    babel
    pycairo
    pygobject3
    dbus-python
  ];

  # Prevent double wrapping because of wrapGAppsHook
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH ":" "${lib.makeBinPath [ slop ]}"
      "''${gappsWrapperArgs[@]}"
      )
  '';

  # screenkey does not have any tests
  doCheck = false;

  # Fix CDLL python calls for non absolute paths of xorg libraries
  postPatch = ''
    substituteInPlace Screenkey/xlib.py \
      --replace libX11.so.6 ${lib.getLib xorg.libX11}/lib/libX11.so.6 \
      --replace libXtst.so.6 ${lib.getLib xorg.libXtst}/lib/libXtst.so.6
  '';

  meta = with lib; {
    homepage = "https://www.thregr.org/~wavexx/software/screenkey/";
    description = "A screencast tool to display your keys inspired by Screenflick";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
    mainProgram = "screenkey";
  };
}
