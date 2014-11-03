{ stdenv, lib, fetchurl, buildPythonPackage, pythonPackages, pygtk, pygobject, python }:

#
# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).
#

buildPythonPackage rec {
  name = "zim-${version}";
  version = "0.60";
  namePrefix = "";
  
  src = fetchurl {
    url = "http://zim-wiki.org/downloads/zim-0.61.tar.gz";
    sha256 = "0jncxkf83bwra3022jbvjfwhk5w8az0jlwr8nsvm7wa1zfrajhsq";
  };

  propagatedBuildInputs = [ pythonPackages.sqlite3 pygtk /*pythonPackages.pyxdg*/ pygobject ];

  preBuild = ''
    mkdir -p /tmp/home
    export HOME="/tmp/home"
  '';
  
  setupPyInstallFlags = ["--skip-xdg-cmd"];
  
  #
  # Exactly identical to buildPythonPackage's version but for the
  # `--old-and-unmanagable`, which I removed. This was removed because
  # this is a setuptools specific flag and as zim is overriding 
  # the install step, setuptools could not perform its monkey
  # patching trick for the command. Alternate solutions were to
  #
  #  -  Remove the custom install step (tested as working but
  #	also remove the possibility of performing the xdg-cmd
  #     stuff).
  #  -  Explicitly replace distutils import(s) by their setuptools
  #	equivalent (untested). 
  #
  # Both solutions were judged unsatisfactory as altering the code
  # would be required.
  #
  # Note that a improved solution would be to expose the use of 
  # the `--old-and-unmanagable` flag as an option of passed to the
  # buildPythonPackage function.
  #
  # Also note that I stripped all comments.
  #
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out" ${lib.concatStringsSep " " setupPyInstallFlags}

    eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
    if [ -e "$eapth" ]; then
	# move colliding easy_install.pth to specifically named one
	mv "$eapth" $(dirname "$eapth")/${name}.pth
    fi

    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

    runHook postInstall
  '';

  # FIXME: this is quick and dirty hack, because zim expects the
  # path to the executable in argv[0] therefore the wrapper is
  # modified accordingly.
  postFixup = ''
    wrapPythonPrograms

    sed -i "s#sys\.argv\[0\] = 'zim'#sys.argv[0] = '$out/bin/zim'#g" \
      $out/bin/.zim-wrapped

    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi

    createBuildInputsPth build-inputs "$buildInputStrings"
    for inputsfile in propagated-build-inputs propagated-native-build-inputs; do
      if test -e $out/nix-support/$inputsfile; then
          createBuildInputsPth $inputsfile "$(cat $out/nix-support/$inputsfile)"
      fi
    done
  '';
  
  # Testing fails.
  doCheck = false;

  meta = {
      description = "A desktop wiki";
      homepage = http://zim-wiki.org;
      license = stdenv.lib.licenses.gpl2Plus;
  };
}

