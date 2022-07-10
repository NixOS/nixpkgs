{ lib
, fetchFromGitHub
, python3
, python3Packages
, mypy
, glib
, pango
, pkg-config
, libinput
, libxkbcommon
, wayland
, wlroots
, xcbutilcursor
}:

let
  unwrapped = python3Packages.buildPythonPackage rec {
    pname = "qtile";
    version = "0.21.0";

    src = fetchFromGitHub {
      owner = "qtile";
      repo = "qtile";
      rev = "v${version}";
      sha256 = "3QCI1TZIh1LcWuklVQkqgR1MQphi6CzZKc1UZcytV0k=";
    };

    patches = [
      ./fix-restart.patch # https://github.com/NixOS/nixpkgs/issues/139568
    ];

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
    ] ++ (with python3Packages; [
      setuptools-scm
    ]);

    propagatedBuildInputs = with python3Packages; [
      xcffib
      (cairocffi.override { withXcffib = true; })
      setuptools
      python-dateutil
      dbus-python
      dbus-next
      mpd2
      psutil
      pyxdg
      pygobject3
      pywayland
      pywlroots
      xkbcommon
    ];

    buildInputs = [
      libinput
      wayland
      wlroots
      libxkbcommon
    ];

    # for `qtile check`, needs `stubtest` and `mypy` commands
    makeWrapperArgs = [
      "--suffix PATH : ${lib.makeBinPath [ mypy ]}"
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
(python3.withPackages (_: [ unwrapped ])).overrideAttrs (_: {
  # otherwise will be exported as "env", this restores `nix search` behavior
  name = "${unwrapped.pname}-${unwrapped.version}";
  # export underlying qtile package
  passthru = { inherit unwrapped; };

  # restore original qtile attrs
  inherit (unwrapped) pname version meta;
})
