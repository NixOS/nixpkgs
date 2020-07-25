{
stdenv, fetchFromGitHub, python37Packages, glib, cairo, pango, pkgconfig, libxcb, xcbutilcursor,
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

  checkInputs = [ pypa.pytest xvfb_run xrandr xcalc xeyes xclock ];

  preCheck = ''
    HOME=$(mktemp -d) #tests need a home directory
  '';

  checkPhase = ''
    runHook preCheck

    # TODO This is taken from scripts/ffibuild but excluding the pulse component, which we dont build,
    # I'm not sure why it doesn't seem to need to be run for the build phase?
    echo "building pango"
    python3 ./libqtile/pango_ffi_build.py
    echo "building xcursors"
    python3 ./libqtile/backend/x11/xcursors_ffi_build.py

    xvfb-run -s '-screen 0 800x600x24' \
      pytest -vv \
        `#These fail during collection due to missing deps` \
        --ignore=test/test_bar.py \
        --ignore=test/test_fakescreen.py \
        --ignore=test/test_images2.py

    runHook postCheck
  '';

  postCheck = ''
    HOME=/homeless-shelter
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
