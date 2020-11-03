{ lib
, fetchFromGitLab
# native
, intltool
, wrapGAppsHook
, file
# not native
, xorg
, gobject-introspection
, gtk3
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "screenkey";
  version = "1.2";

  src = fetchFromGitLab {
    owner = "screenkey";
    repo = "screenkey";
    rev = "v${version}";
    sha256 = "1x13n57iy2pg3h3r994q3g5nbmh2gwk3qidmmcv0g7qa89n2gwbj";
  };

  nativeBuildInputs = [
    python3.pkgs.distutils_extra
    # Shouldn't be needed once https://gitlab.com/screenkey/screenkey/-/issues/122 is fixed.
    intltool
    # We are not sure why is this needed, but without it we get "file: command
    # not found" errors during build.
    file
    wrapGAppsHook
    # for setup hook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
  ];

  requiredPythonModules = with python3.pkgs; [
    pycairo
    pygobject3
  ];

  # Prevent double wrapping because of wrapGAppsHook
  dontWrapGApps = true;
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
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
  };
}
