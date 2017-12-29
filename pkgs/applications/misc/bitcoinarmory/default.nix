{ stdenv, fetchFromGitHub, pythonPackages
, pkgconfig, autoreconfHook, rsync
, swig, qt4, fcgi
, bitcoin, procps, utillinux
}:
let

  version = "0.96.1";
  sitePackages = pythonPackages.python.sitePackages;
  inherit (pythonPackages) mkPythonDerivation pyqt4 psutil twisted;

in mkPythonDerivation {

  name = "bitcoinarmory-${version}";

  src = fetchFromGitHub {
    owner = "goatpig";
    repo = "BitcoinArmory";
    rev = "v${version}";
    #sha256 = "023c7q1glhrkn4djz3pf28ckd1na52lsagv4iyfgchqvw7qm7yx2";
    sha256 = "0pjk5qx16n3kvs9py62666qkwp2awkgd87by4karbj7vk6p1l14h"; fetchSubmodules = true;
  };

  # FIXME bitcoind doesn't die on shutdown. Need some sort of patch to fix that.
  #patches = [ ./shutdown-fix.patch ];

  buildInputs = [
    pkgconfig
    autoreconfHook
    swig
    qt4
    fcgi
    rsync # used by silly install script (TODO patch upstream)
  ];

  propagatedBuildInputs = [
    pyqt4
    psutil
    twisted
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  makeWrapperArgs = [
    "--prefix            PATH : ${bitcoin}/bin"   # for `bitcoind`
    "--prefix            PATH : ${procps}/bin"    # for `free`
    "--prefix            PATH : ${utillinux}/bin" # for `whereis`
    "--suffix LD_LIBRARY_PATH : $out/lib"         # for python bindings built as .so files
    "--run    cd\\ $out/lib/armory"               # so that GUI resources can be loaded
  ];

  # auditTmpdir runs during fixupPhase, so patchelf before that
  preFixup = ''
    newRpath=$(patchelf --print-rpath $out/bin/ArmoryDB | sed -r 's|(.*)(/tmp/nix-build-.*libfcgi/.libs:?)(.*)|\1\3|')
    patchelf --set-rpath $out/lib:$newRpath $out/bin/ArmoryDB
  '';

  # fixupPhase of mkPythonDerivation wraps $out/bin/*, so this needs to come after
  postFixup = ''
    wrapPythonProgramsIn $out/lib/armory "$out $pythonPath"
    ln -sf $out/lib/armory/ArmoryQt.py $out/bin/armory
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
    maintainers = with stdenv.lib.maintainers; [ elitak ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

}
