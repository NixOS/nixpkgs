{
stdenv, fetchFromGitHub, substituteAll,
# dependencies
python37Packages, glib, cairo, pango, pkgconfig, libxcb, xcbutilcursor, librsvg,
# for tests, see http://docs.qtile.org/en/v0.16.0/manual/hacking.html
xvfb_run, xrandr, xcalc, xeyes, xclock, xterm, imagemagick
}:

let 
  pypa = python37Packages;
  cairocffi-xcffib = python37Packages.cairocffi.override {
    withXcffib = true;
  };
  version = "0.16.0";
in

pypa.buildPythonApplication {
  name = "qtile-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "v${version}";
    sha256 = "1klv1k9847nyx71sfrhqyl1k51k2w8phqnp2bns4dvbqii7q125l";
  };

  patches = [
    (substituteAll {
      src = ./0001-Substitution-vars-for-absolute-paths.patch;
      glib = glib.out;
      pango = pango.out;
      inherit xcbutilcursor;
      })
    ./0002-Restore-PATH-and-PYTHONPATH.patch
    (substituteAll {
      src = ./0003-Restart-executable.patch;
      out = "$out";
      })
    ./0004-Keep-env-in-test-process-spawner.patch #TODO upstream this
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxcb cairo pango pypa.xcffib librsvg ]; 

  pythonPath = with pypa; [ xcffib cairocffi-xcffib setuptools setuptools_scm ]; 

  checkInputs = [ pypa.pytest pypa.pytest-rerunfailures xvfb_run xrandr xcalc xeyes xclock xterm pypa.psutil imagemagick ];

  checkPhase = ''
    runHook preCheck

    oldhome="$HOME"
    HOME=$(mktemp -d) #tests need a home directory

    # This is taken from scripts/ffibuild but excluding the pulse component, which we dont build,
    echo "building pango"
    python3 ./libqtile/pango_ffi_build.py
    echo "building xcursors"
    python3 ./libqtile/backend/x11/xcursors_ffi_build.py

    patchShebangs /build/source/bin/*
    export GDK_PIXBUF_MODULE_FILE="${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" #TODO is there a better way to do this?
    #TODO figure out why tests fail nondeterministically, after fixing, pytest-rerunfailures will be unnecessary
    # error: xcffib.ConnectionException: xcb connection errors because of socket, pipe and other stream errors.
    xvfb-run -s '-screen 0 1024x768x24' pytest -vv --reruns 5

    HOME="$oldhome"

    runHook postCheck
  '';

  postInstall = ''
    wrapProgram $out/bin/qtile \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --set QTILE_WRAPPER '$0' \
      --set QTILE_SAVED_PYTHONPATH '$PYTHONPATH' \
      --set QTILE_SAVED_PATH '$PATH'
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.qtile.org/";
    license = licenses.mit;
    description = "A small, flexible, scriptable tiling window manager written in Python";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kamilchm ];
  };
}
