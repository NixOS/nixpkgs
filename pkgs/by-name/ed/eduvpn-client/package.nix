{ lib, fetchurl
, go
, libsecret
, libnotify
, networkmanager
, gtk3
, gobject-introspection
, python3Packages
, wrapGAppsHook
, pango
}:
let
  eduvpn-common = python3Packages.buildPythonPackage rec {
    pname = "eduvpn-common";
    version = "1.2.0";
    src = fetchurl {
      url = "https://github.com/eduvpn/eduvpn-common/releases/download/1.2.0/eduvpn-common-1.2.0.tar.xz";
      sha256 = "sha256-CqpOgvGGD6pW03fvKUzgoeCz6YgnzuYK2u5Zbw+/Ks4=";
    };

    format = "pyproject";

    nativeBuildInputs = [
      go
    ];

    propagatedBuildInputs = with python3Packages; [
      wheel
      pip
      setuptools
    ];

    pythonImportsCheck = [ "eduvpn_common" ];

    preBuild = ''
      HOME="$(mktemp -d)"
      GOFLAGS="-tags=release" make
      export EXPORTS_PATH=$(pwd)/exports
      cd wrappers/python
    '';

    meta = {
      description = "Code to be shared between eduVPN clients";
      homepage = "https://github.com/eduvpn/eduvpn-common";
      changelog = "https://github.com/eduvpn/eduvpn-common/blob/${version}/CHANGES.md";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ benneti ];
    };
  };
in python3Packages.buildPythonApplication rec {
  pname = "eduvpn-client";
  version = "4.2.0";
  src = fetchurl {
    url = "https://github.com/eduvpn/python-eduvpn-client/releases/download/4.2.0/python-eduvpn-client-4.2.0.tar.xz";
    sha256 = "sha256-W5z0ykrwWANZmW+lQt6m+BmYPI0cutsamx8V2JrpeHA=";
  };

  nativeBuildInputs = [
    gobject-introspection
  ];

  buildInputs = [
    networkmanager
    libsecret
    libnotify
    pango
    gtk3
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    eduvpn-common
    pycodestyle pytest
    pygobject3
    pynacl
    dbus-python
    requests-oauthlib
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}"
    )
  '';

  postInstall = ''
    substituteInPlace $out/${python3Packages.python.sitePackages}/eduvpn/utils.py --replace '/usr/local' "$out"
  '';

  meta = {
    description = "Linux client for eduVPN";
    homepage = "https://github.com/eduvpn/python-eduvpn-client";
    changelog = "https://github.com/eduvpn/python-eduvpn-client/blob/${version}/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ benneti ];
    mainProgram = "eduvpn-gui";
    platforms = lib.platforms.linux;
  };
}
