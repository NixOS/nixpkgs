{ lib, fetchFromGitHub, python3, glib, cairo, pango, pkg-config, libxcb, xcbutilcursor }:

let
  enabled-xcffib = cairocffi-xcffib: cairocffi-xcffib.override {
    withXcffib = true;
  };

  # make it easier to reference python
  python = python3;
  pythonPackages = python.pkgs;

  unwrapped = pythonPackages.buildPythonPackage rec {
    pname = "qtile";
    version = "0.18.1";

    src = fetchFromGitHub {
      owner = "qtile";
      repo = "qtile";
      rev = "v${version}";
      sha256 = "0ln0fxarin9liy9n76zywmbr31xrjw8f7d3nr1mphci7wkc9bqmm";
    };

    postPatch = ''
      substituteInPlace libqtile/pangocffi.py \
        --replace libgobject-2.0.so.0 ${glib.out}/lib/libgobject-2.0.so.0 \
        --replace libpangocairo-1.0.so.0 ${pango.out}/lib/libpangocairo-1.0.so.0 \
        --replace libpango-1.0.so.0 ${pango.out}/lib/libpango-1.0.so.0
      substituteInPlace libqtile/backend/x11/xcursors.py \
        --replace libxcb-cursor.so.0 ${xcbutilcursor.out}/lib/libxcb-cursor.so.0
    '';

    SETUPTOOLS_SCM_PRETEND_VERSION = version;

    nativeBuildInputs = [
      pkg-config
    ] ++ (with pythonPackages; [
      setuptools-scm
    ]);

    propagatedBuildInputs = with pythonPackages; [
      xcffib
      (enabled-xcffib cairocffi)
      setuptools
      python-dateutil
      dbus-python
      mpd2
      psutil
      pyxdg
      pygobject3
      pywayland
      pywlroots
      xkbcommon
    ];

    doCheck = false; # Requires X server #TODO this can be worked out with the existing NixOS testing infrastructure.

    meta = with lib; {
      homepage = "http://www.qtile.org/";
      license = licenses.mit;
      description = "A small, flexible, scriptable tiling window manager written in Python";
      platforms = platforms.linux;
      maintainers = with maintainers; [ kamilchm ];
    };
  };
in
  (python.withPackages (ps: [ unwrapped ])).overrideAttrs (_: {
    # otherwise will be exported as "env", this restores `nix search` behavior
    name = "${unwrapped.pname}-${unwrapped.version}";
    # export underlying qtile package
    passthru = { inherit unwrapped; };
  })
