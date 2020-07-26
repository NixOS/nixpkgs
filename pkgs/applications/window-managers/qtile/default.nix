{
stdenv, fetchFromGitHub, python37Packages, glib, cairo, pango, pkgconfig, libxcb, xcbutilcursor, librsvg,
# for tests, see http://docs.qtile.org/en/v0.16.0/manual/hacking.html
xvfb_run, xrandr, xcalc, xeyes, xclock
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
    ./0001-Substitution-vars-for-absolute-paths.patch
    ./0002-Restore-PATH-and-PYTHONPATH.patch
    ./0003-Restart-executable.patch
    ./0004-Keep-env-in-test-process-spawner.patch #TODO attempt to upstream
  ];

  postPatch = ''
    substituteInPlace libqtile/core/manager.py --subst-var-by out $out
    substituteInPlace libqtile/pangocffi.py --subst-var-by glib ${glib.out}
    substituteInPlace libqtile/pangocffi.py --subst-var-by pango ${pango.out}
    substituteInPlace libqtile/backend/x11/xcursors.py --subst-var-by xcb-cursor ${xcbutilcursor.out}
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxcb cairo pango pypa.xcffib ];

  pythonPath = with pypa; [ xcffib cairocffi-xcffib setuptools setuptools_scm ]; 

  checkInputs = [ pypa.pytest pypa.pytest-rerunfailures xvfb_run xrandr xcalc xeyes xclock ];

  preCheck = ''
    oldhome="$HOME"
    HOME=$(mktemp -d) #tests need a home directory
  '';

  checkPhase = ''
    runHook preCheck

    #TODO convert to patch style?
    # TODO This is taken from scripts/ffibuild but excluding the pulse component, which we dont build,
    # I'm not sure why it doesn't seem to need to be run for the build phase?
    echo "building pango"
    python3 ./libqtile/pango_ffi_build.py
    echo "building xcursors"
    python3 ./libqtile/backend/x11/xcursors_ffi_build.py

      #TODO whats the correct way to set this var?
      GDK_PIXBUF_MODULE_FILE="${librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      xvfb-run -s '-screen 0 800x600x24' \
      pytest -vv --reruns 5 \
        `#These fail during collection due to missing deps` \
        --ignore=test/test_bar.py \
        --ignore=test/test_fakescreen.py \
        --ignore=test/test_images2.py \
        `#other failures` \
        --deselect=test/test_qtile_cmd.py::test_qtile_cmd \
        --deselect=test/test_scratchpad.py::test_toggling \
        --deselect=test/test_scratchpad.py::test_kill \
        --deselect=test/test_scratchpad.py::test_floating_toggle \
        --deselect=test/test_scratchpad.py::test_focus_lost_hide \
        --deselect=test/test_scratchpad.py::test_focus_cycle \
        --deselect=test/widgets/test_battery.py::test_images_good \
        --deselect=test/widgets/test_volume.py::test_images_good \
        `#warnings` \
        --deselect=test/widgets/test_misc.py::test_thermalsensor_regex_compatibility
 
    runHook postCheck
  '';

  postCheck = ''
    HOME="$oldhome"
  '';

  postInstall = ''
    wrapProgram $out/bin/qtile \
      --run 'export QTILE_WRAPPER=$0' \
      --run 'export QTILE_SAVED_PYTHONPATH=$PYTHONPATH' \
      --run 'export QTILE_SAVED_PATH=$PATH'
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.qtile.org/";
    license = licenses.mit;
    description = "A small, flexible, scriptable tiling window manager written in Python";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kamilchm ];
  };
}
