{
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  python3,
  copyDesktopItems,
  makeDesktopItem,
  pkg-config,
  SDL2,
  which,
  yad,
}:
let
  # see pyproject.toml in steamos-devkit
  pyimgui = python3.pkgs.buildPythonPackage {
    pname = "pyimgui";
    version = "2.0.0-dev";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "pyimgui";
      repo = "pyimgui";
      rev = "5842ee415f9357a9418cc8341d621b6e1e2aaddd";
      fetchSubmodules = true;
      sha256 = "sha256-YuDLzm5QKuDjmcGHVbqxP5GwBFCvmBLYtPlKoHxZu6U=";
    };

    nativeBuildInputs = with python3.pkgs; [
      cython
      pkg-config
      SDL2
    ];

    propagatedBuildInputs = with python3.pkgs; [
      click
      pyopengl
      pysdl2
    ];

    # Requires OpenGL acceleration
    doCheck = false;
    pythonImportsCheck = [ "imgui" ];
  };

  # see pyproject.toml in steamos-devkit
  xdialog = python3.pkgs.buildPythonPackage rec {
    pname = "xdialog";
    version = "c55ca29e69b124818a960d55e3ca0c7e559a8dda";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "TTimo";
      repo = "xdialog";
      rev = version;
      fetchSubmodules = true;
      sha256 = "sha256-oSekemXXofQFSBa6UqiuW8311sgV6JSb4vInBJEvVu0=";
    };

    postPatch = ''
      substituteInPlace xdialog/__init__.py --replace-fail "'which'" "'${which}/bin/which'"
      substituteInPlace xdialog/__init__.py --replace-fail "'yad'" "'${yad}/bin/yad'"
    '';

    buildInputs = [
      copyDesktopItems
    ];

    pythonImportsCheck = [ "xdialog" ];
  };

  steamos-devkit-script = ''
    #!${python3.interpreter}
    import os

    # Change the cwd to avoid imgui using cwd which often is ~ to store the state, use the same location as the settings
    path = os.path.expanduser(os.path.join("~", ".devkit-client-gui"))
    os.makedirs(path, exist_ok=True)
    os.chdir(path)

    # Workaround to get pysdl to work on wayland, remove when https://gitlab.steamos.cloud/devkit/steamos-devkit/-/issues/1 is solved.
    if os.environ.get("XDG_SESSION_TYPE") == "wayland":
      os.environ["SDL_VIDEODRIVER"] = "wayland"

    import devkit_client.gui2
    devkit_client.gui2.main()
  '';
in
python3.pkgs.buildPythonPackage rec {
  pname = "steamos-devkit";
  version = "0.20260803.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.steamos.cloud";
    owner = "devkit";
    repo = "steamos-devkit";
    rev = "v${version}";
    sha256 = "sha256-gMeOVn5aMSlyLQ2CLCsdbPn0UZCi4otOFVGakAl7+T8=";
  };

  dependencies = with python3.pkgs; [
    appdirs
    bcrypt
    cffi
    cryptography
    idna
    ifaddr
    netifaces-plus
    numpy
    paramiko
    pycparser
    pyimgui
    pynacl
    pysdl2
    setuptools
    shiv
    signalslot
    six
    xdialog
    zeroconf
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  postUnpack = ''
    # Find the absolute source root to link correctly to the previous root
    prevRoot=$(realpath $sourceRoot)

    # Update the source root to the devkit_client package
    sourceRoot="$sourceRoot/client"

    # Link the setup script into the new source root
    ln -s $prevRoot/setup/shiv-linux-setup.py $sourceRoot/setup.py
  '';

  patches = [
    ./0001-make-steamos-devkit-root-relocatable.diff
  ];

  postPatch = ''
    # Move ROOT_DIR from bin to share/steamos-devkit
    substituteInPlace devkit_client/__init__.py --replace-fail "@ROOT_DIR@" "'$out/share/steamos-devkit'"
  '';

  postInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/steamos-devkit

    # These are various assets like scripts that steamos-devkit requires
    cp -R ./devkit-utils $out/share/steamos-devkit/devkit-utils
    cp -R ./logo-steamdeck-256.tga $out/share/steamos-devkit

    # writeScript + symlink will be ignored by wrapPythonPrograms
    # Copying it is undesirable too, just write it directly to a script instead
    cat << EOF > $out/bin/steamos-devkit
    ${steamos-devkit-script}
    EOF
    chmod +x $out/bin/steamos-devkit
  '';

  # There are no checks for steamos-devkit
  doCheck = false;
  pythonImportsCheck = [ "devkit_client" ];

  # importlib.metadata.PackageNotFoundError: No package metadata was found for steamos-devkit
  dontCheckPythonMetadata = true;

  desktopItems = [
    (makeDesktopItem {
      name = "SteamOS-Devkit";
      exec = "steamos-devkit";
      desktopName = "SteamOS Devkit Client";
    })
  ];

  meta = {
    description = "SteamOS Devkit Client";
    mainProgram = "steamos-devkit";
    homepage = "https://gitlab.steamos.cloud/devkit/steamos-devkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ myaats ];
  };
}
