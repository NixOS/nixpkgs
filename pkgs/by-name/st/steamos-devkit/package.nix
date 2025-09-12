{
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  python3,
  copyDesktopItems,
  makeDesktopItem,
  pkg-config,
  SDL2,
}:
let
  # steamos-devkit requires a build of the unreleased pyimgui 2.0 branch, move to pythonPackages when 2.0 is released.
  pyimgui = python3.pkgs.buildPythonPackage {
    pname = "pyimgui";
    version = "2.0.0";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "pyimgui";
      repo = "pyimgui";
      rev = "2.0.0";
      fetchSubmodules = true;
      sha256 = "sha256-sw/bLTdrnPhBhrnk5yyXCbEK4kMo+PdEvoMJ9aaZbsE=";
    };

    nativeBuildInputs = with python3.pkgs; [
      cython_0
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
  version = "0.20240216.0";
  format = "setuptools";

  src = fetchFromGitLab {
    domain = "gitlab.steamos.cloud";
    owner = "devkit";
    repo = "steamos-devkit";
    rev = "v${version}";
    sha256 = "sha256-eOtESkGMIjcijAFITOcYKPsXH6xH/Xcj9D+OItMqebM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    bcrypt
    cffi
    cryptography
    idna
    ifaddr
    netifaces
    numpy
    paramiko
    pycparser
    pyimgui
    pynacl
    pysdl2
    signalslot
    six
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

  postInstall = ''
    mkdir -p $out/bin

    # These are various assets like scripts that steamos-devkit will copy to the remote device
    cp -R ./devkit-utils $out/${python3.sitePackages}/devkit-utils

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

  desktopItems = [
    (makeDesktopItem {
      name = "SteamOS-Devkit";
      exec = "steamos-devkit";
      desktopName = "SteamOS Devkit Client";
    })
  ];

  meta = with lib; {
    description = "SteamOS Devkit Client";
    mainProgram = "steamos-devkit";
    homepage = "https://gitlab.steamos.cloud/devkit/steamos-devkit";
    license = licenses.mit;
    maintainers = with maintainers; [ myaats ];
  };
}
