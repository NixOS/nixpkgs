{ fetchFromGitHub, libxcb, mtools, p7zip, parted, procps, qemu, unzip, zip,
  coreutils, gnugrep, which, gnused, e2fsprogs, autoPatchelfHook, gptfdisk,
  python3Packages, qt5, runtimeShell, lib, util-linux, wrapQtAppsHook }:

# Note: Multibootusb is tricky to maintain. It relies on the
# $PYTHONPATH variable containing some of their code, so that
# something like:
#
# from scripts import config
#
# works. It also relies on the current directory to find some runtime
# resources thanks to a use of __file__.
#
# https://github.com/mbusb/multibootusb/blob/0d34d70c3868f1d7695cfd141141b17c075de967/scripts/osdriver.py#L59

python3Packages.buildPythonApplication rec {
  pname = "multibootusb";
  name = "${pname}-${version}";
  version = "9.2.0";

  nativeBuildInputs = [
    wrapQtAppsHook
    autoPatchelfHook
    unzip
    zip
  ];

  runTimeDeps = [
    coreutils
    gnugrep
    which
    parted
    util-linux
    qemu
    p7zip
    gnused
    mtools
    procps
    e2fsprogs
    gptfdisk
  ];

  buildInputs = [
    libxcb
    python3Packages.python
    qt5.full
  ];

  src = fetchFromGitHub {
    owner = "mbusb";
    repo = pname;
    rev = "v${version}";

    sha256 = "0wlan0cp6c2i0nahixgpmkm0h4n518gj8rc515d579pqqp91p2h3";
  };

  # Tests can't run inside the NixOS sandbox
  # "Failed to connect to socket /run/dbus/system_bus_socket: No such file or directory"
  doCheck = false;

  pythonPath = with python3Packages; [
    dbus-python
    pyqt5
    pytest-shutil
    pyudev
    six
  ];

  # multibootusb ships zips with various versions of syslinux, we need to patchelf them
  postPatch = ''
    for zip in $(find . -name "*.zip"); do
      zip=$(readlink -f $zip)
      target="$(mktemp -d)"
      pushd $target
      unzip $zip
      rm $zip
      autoPatchelf .
      zip -r $zip *
      popd
    done
  '';

  postInstall = ''
    # This script doesn't work and it doesn't add much anyway
    rm $out/bin/multibootusb-pkexec

    # The installed data isn't sufficient for whatever reason, missing gdisk/gdisk.exe
    mkdir -p "$out/share/${pname}"
    cp -r data "$out/share/${pname}/data"
  '';

  preFixup = ''
    makeWrapperArgs+=(
      # Firstly, add all necessary QT variables
      "''${qtWrapperArgs[@]}"

      # Then, add the installed scripts/ directory to the python path
      --prefix "PYTHONPATH" ":" "$out/lib/${python3Packages.python.libPrefix}/site-packages"

      # Add some runtime dependencies
      --prefix "PATH" ":" "${lib.makeBinPath runTimeDeps}"

      # Finally, move to directory that contains data
      --run "cd $out/share/${pname}"
    )
  '';

  meta = with lib; {
    description = "Multiboot USB creator for Linux live disks";
    homepage = "http://multibootusb.org/";
    license = licenses.gpl2;
    maintainers = []; # Looking for a maintainer!
    broken = true; # "name 'config' is not defined", added 2021-02-06
  };
}
