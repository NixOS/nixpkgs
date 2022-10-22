{ lib
, fetchFromGitLab
# native
, wrapGAppsHook
# not native
, xorg
, gobject-introspection
, gtk3
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "screenkey";
  version = "1.4";

  src = fetchFromGitLab {
    owner = "screenkey";
    repo = "screenkey";
    rev = "v${version}";
    sha256 = "1rfngmkh01g5192pi04r1fm7vsz6hg9k3qd313sn9rl9xkjgp11l";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    # for setup hook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    babel
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
