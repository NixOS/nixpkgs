{ lib, fetchFromGitHub, fetchpatch, python3, libnotify, gobject-introspection, wrapGAppsHook, gtk3, stdenv }:

# need to override this as astral 2.0 has breaking changes
let
  python3_ = python3.override {
    packageOverrides = self: super: {
      astral = super.astral.overrideAttrs (old: rec {
        version = "1.10.1";
        src = super.fetchPypi {
          inherit version;
          pname = "astral";
          sha256 = "sha256-0qZyQ8RQMTHIVsr7GxJ23lKobluKHVB7fgi+5Ry2e/E=";
        };
      });
    };
  };

in python3_.pkgs.buildPythonApplication rec {
  pname = "automathemely";
  version = "2022-02-24";

  src = fetchFromGitHub {
    owner = "C2N14";
    repo = "AutomaThemely";
    rev = "3f6f9973eb78c707454b53a26dbe746f8667a924";
    sha256 = "sha256-90EKU1ycu+AY+ZVRPIC9sKn1w292r6wFMWp+qHC6czE=";
  };

  patches = [
    # fixes restrictive permissions caused by copying files from the nix store
    (fetchpatch {
      name = "fix-copying-from-nix-store.patch";
      url = "https://github.com/LuisChDev/AutomaThemely/commit/b9c26ad7e476809b9e8038c8cdafa1637380f11d.patch";
      sha256 = "sha256-qmLKvog65TWdRfQTjSVJaS82kMqJdAv1QeGacwpbOEM=";
    })
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  propagatedBuildInputs = with python3_.pkgs; [
    astral
    requests
    pytz
    tzlocal
    schedule
    pygobject3 # implicit dependency
    gobject-introspection

    libnotify
    gtk3
  ];

  strictDeps = false;

  postPatch = ''
    find -name "*.py" -print0 | while IFS= read -r -d ''' file; do
      patchShebangs "$file"
    done

    substituteInPlace automathemely/lib/installation_files/autostart.desktop \
    --replace '/usr/bin/env python3' '${python3}/bin/python3'

    substituteInPlace automathemely/lib/installation_files/sun-times.service \
    --replace '/usr/bin/env python3' '${python3}/bin/python3'

    substituteInPlace automathemely/lib/installation_files/sun-times.service \
    --replace '/bin/bash' '${stdenv.shell}'

    # tries to call itself during install just to read the version. And this causes  an attempt to read $HOME
    substituteInPlace setup.py --replace 'from automathemely import __version__ as version' ' '
    substituteInPlace setup.py --replace 'version=version' 'version="${version}"'
  '';

  doCheck = false; # no tests anyway, and again tries to access $HOME

  meta = with lib; {
    description =
      "Simple, set-and-forget python application for changing between desktop themes according to light and dark hours";
    license = licenses.gpl3;
  };
}
