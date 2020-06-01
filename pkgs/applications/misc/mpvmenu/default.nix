{ stdenv, fetchFromGitHub
, gtk3, gobject-introspection, python3, wrapGAppsHook
}:
python3.pkgs.buildPythonApplication rec {
  pname = "mpvmenu";
  version = "unstable-2018-10-23";
  format = "other";

  src = fetchFromGitHub {
    owner = "nezumisama";
    repo = "mpvmenu";
    rev = "a1bc2e803c3b00a614282dde48d1c38547578eb2";
    sha256 = "0sk5xsdzz30nn8mzx6mc2krm960sjw3gdl48dr0jmglxfp0snz09";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [ gobject-introspection gtk3 ];

  propagatedBuildInputs = with python3.pkgs; [ pygobject3 ];

  # To use wrapGAppsHook
  strictDeps = false;

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp mpvmenu $out/bin
  '';
  passthru.scriptName = "mpvmenu";

  # Avoid double-wrapping
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with stdenv.lib; {
    description = "Pop-up menu for mpv on X11";
    homepage = "https://github.com/nezumisama/mpvmenu";
    license = licenses.gpl2;
    maintainers = [ maintainers.berbiche ];
    platforms = platforms.linux;
    longDescription = ''
      Requires the `input-ipc-server` option of mpv to be enabled
      and set to `/run/user/$UID/mpv.sock` where `$UID` is your
      user id (the result of `id -u` or `$UID`).
    '';
  };
}
