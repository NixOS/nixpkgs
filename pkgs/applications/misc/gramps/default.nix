{ stdenv, fetchurl, gtk3, pythonPackages, intltool,
  pango, gsettings_desktop_schemas }:

let
  inherit (pythonPackages) python buildPythonApplication;
in buildPythonApplication rec {
  version = "4.1.1";
  name = "gramps-${version}";

  buildInputs = [ intltool gtk3 ];

  # Currently broken
  doCheck = false;

  src = fetchurl {
    url = "mirror://sourceforge/gramps/Stable/${version}/${name}.tar.gz";
    sha256 = "0jdps7yx2mlma1hdj64wssvnqd824xdvw0bmn2dnal5fn3h7h060";
  };

  pythonPath = with pythonPackages; [ pygobject3 pycairo bsddb ] ++ [ pango ];

  # Same installPhase as in buildPythonApplication but without --old-and-unmanageble
  # install flag.
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"

    eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
    if [ -e "$eapth" ]; then
        # move colliding easy_install.pth to specifically named one
        mv "$eapth" $(dirname "$eapth")/${name}.pth
    fi

    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

    runHook postInstall
  '';

  # gobjectIntrospection package, wrap accordingly
  preFixup = ''
    wrapProgram $out/bin/gramps \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
  '';

  meta = with stdenv.lib; {
    description = "Genealogy software";
    homepage = http://gramps-project.org;
    license = licenses.gpl2;
  };
}
