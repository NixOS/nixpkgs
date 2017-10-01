{ stdenv, autoreconfHook, bitcoin, cryptopp, fcgi, fetchFromGitHub
, lmdb, pkgconfig, procps, pythonPackages, qt4, rsync, swig, utillinux
}:

let

  inherit (pythonPackages) mkPythonDerivation pyqt4 psutil twisted;

in mkPythonDerivation rec {

  name = "bitcoinarmory-${version}";
  version = "0.96.3";

  src = fetchFromGitHub {
    owner = "goatpig";
    repo = "BitcoinArmory";
    rev = "v${version}";
    sha256 = "1nbdhmyk9nm771fvmn5bd5id14xr4ijsnbxbs7c8my6l8drr06q3";
  };

  patches = [ ./automake.patch ];

  postPatch = ''
    # Remove a bunch of unused stuff & the ones we’re taking from
    # Nixpkgs, so that we get real compilation errors (hopefully).
    rm -r dpkgfiles/{armory,control*,copyright,make_*,post*,rules}
    rm -r PublicKeys extras guitest linuxbuild osxbuild r-pi release_scripts
    rm -r samplemodules urllib3 webshop windowsbuild README_OSX.md
    rm -r edit_icons.bat edit_icons.rts nginx_example.conf subprocess_win.py
    rm -r update_version.py writeNSISCompilerArgs.py ArmorySetup.nsi

    mv cppForSwig/cryptopp/DetSign.* cppForSwig/
    mv cppForSwig/lmdb/lmdbpp.* cppForSwig/

    rm -r cppForSwig/{BitcoinArmory_CppTests,BDM_Client,BlockDataManager}
    rm -r cppForSwig/{ContainerTests,DB1kIterTest,LMDB_Win}
    rm -r cppForSwig/{cryptopp,fcgi}
    rm -r cppForSwig/guardian/{*.sln,*.vc*proj*}
    rm -r cppForSwig/{leveldb_windows_port,leveldbwin,lmdb}
    rm -r cppForSwig/BitcoinArmory.sln
  '';

  # TODO: are pytest/* run at all?

  # TODO: are cppForSwig/gtest/* run at all?

  # TODO: maybe use `jasvet.py` from its upstream? But where is it?

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ swig qt4 fcgi cryptopp lmdb ];

  propagatedBuildInputs = [ pyqt4 psutil twisted ];

  makeWrapperArgs = [
    "--prefix            PATH : ${bitcoin}/bin"   # for `bitcoind`
    "--prefix            PATH : ${procps}/bin"    # for `free`
    "--prefix            PATH : ${utillinux}/bin" # for `whereis`
    "--suffix LD_LIBRARY_PATH : $out/lib"         # for python bindings built as .so files
    "--run    cd\\ $out/lib/armory"               # so that GUI resources can be loaded
  ];

  postInstall = ''
    ln -sf $out/lib/armory/ArmoryQt.py $out/bin/armory
    mkdir -p $out/share/applications
    cp dpkgfiles/*.desktop $out/share/applications/
  '';

  # fixupPhase of mkPythonDerivation wraps $out/bin/*, so this needs to come after
  postFixup = ''
    wrapPythonProgramsIn $out/lib/armory "$out $pythonPath"
  '';

  meta = {
    description = "Bitcoin wallet with cold storage and multi-signature support";
    longDescription = ''
      Armory is the most secure and full featured solution available for users
      and institutions to generate and store Bitcoin private keys. This means
      users never have to trust the Armory team and can use it with the Glacier
      Protocol. Satoshi would be proud!

      Users are empowered with multiple encrypted Bitcoin wallets and permanent
      one-time ‘paper backups’. Armory pioneered cold storage and distributed
      multi-signature. Bitcoin cold storage is a system for securely storing
      Bitcoins on a completely air-gapped offline computer.

      Maintainer's note: The original authors at https://bitcoinarmory.com/
      discontinued development. I elected instead to package GitHub user
      @goatpig's fork, as it's the most active, at time of this writing.
    '';
    homepage = https://github.com/goatpig/BitcoinArmory;
    license = stdenv.lib.licenses.agpl3Plus;
    maintainers = with stdenv.lib.maintainers; [ elitak michalrus ];
    platforms = stdenv.lib.platforms.linux;
  };

}
