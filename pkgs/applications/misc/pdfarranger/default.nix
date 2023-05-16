<<<<<<< HEAD
{ fetchFromGitHub
, lib
, wrapGAppsHook
, python3Packages
, gtk3
, poppler_gi
=======
{ fetchFromGitHub, lib
, wrapGAppsHook, intltool
, python3Packages, gtk3, poppler_gi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec {
  pname = "pdfarranger";
<<<<<<< HEAD
  version = "1.10.0";
=======
  version = "1.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-tNLy3HeHh8nBtmfJS5XhKX+KhIBnuUV2C8LwQl3mQLU=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ] ++ (with python3Packages; [
    setuptools
  ]);

  buildInputs = [
    gtk3
    poppler_gi
=======
    sha256 = "sha256-nZSP9JBbUPG9xk/ATXUYkjyP344m+e7RQS3BiFVzQf4=";
  };

  nativeBuildInputs = [
    wrapGAppsHook intltool
  ] ++ (with python3Packages; [
    setuptools distutils_extra
  ]);

  buildInputs = [
    gtk3 poppler_gi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pikepdf
    img2pdf
    setuptools
    python-dateutil
  ];

  # incompatible with wrapGAppsHook
  strictDeps = false;
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false; # no tests

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Merge or split pdf documents and rotate, crop and rearrange their pages using an interactive and intuitive graphical interface";
    platforms = platforms.linux;
    maintainers = with maintainers; [ symphorien ];
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    changelog = "https://github.com/pdfarranger/pdfarranger/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
