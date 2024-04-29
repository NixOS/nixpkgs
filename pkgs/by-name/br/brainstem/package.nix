{ stdenv
, lib
, autoPatchelfHook
, fetchzip
, curl
, systemd
, zlib
, writeText
, withUpdater ? true
, ...
}:

let
  version = "2.10.5";
  # Upstream has a udev.sh script asking for mode and group, but with uaccess we
  # don't need any of that and can make it entirely static.
  # For any rule adding the uaccess tag to be effective, the name of the file it
  # is defined in has to lexically precede 73-seat-late.rules.
  udevRule = writeText "60-brainstem.rules" ''
    # Acroname Brainstem control devices
    SUBSYSTEM=="usb", ATTRS{idVendor}=="24ff", TAG+="uaccess"

    # Acroname recovery devices (pb82, pb242, pb167)
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0424", ATTRS{idProduct}=="274e", TAG+="uaccess"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0130", TAG+="uaccess"
  '';

  src = fetchzip {
    url = "https://acroname.com/sites/default/files/software/brainstem_sdk/${version}/brainstem_sdk_${version}_Ubuntu_LTS_22.04_x86_64.tgz";
    hash = "sha256-S6u9goxTMCI12sffP/WKUF7bv0pLeNmNog7Hle+vpR4=";
    # There's no "brainstem" parent directory in the archive.
    stripRoot = false;
  };
in

stdenv.mkDerivation {
  pname = "brainstem";
  inherit version src;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    # libudev
    (lib.getLib systemd)
    # libstdc++.so libgcc_s.so
    stdenv.cc.cc.lib
  ] ++ lib.optionals withUpdater [
    # libcurl.so.4
    curl
    # libz.so.1
    zlib
  ];

  # Unpack the CLI tools, documentation, library and C headers.
  # There's also a python .whl, containing more libraries, which might be used
  # to support more architectures, too, but let's only do that if we need it.
  installPhase = ''
    mkdir -p $out/bin
    install -m744 cli/AcronameHubCLI $out/bin
    install -m744 cli/Updater $out/bin/AcronameHubUpdater

    mkdir -p $out/lib/udev/rules.d
    cp ${udevRule} $out/lib/udev/rules.d/60-brainstem.rules

    mkdir -p $doc
    cp docs/* $doc/
    cp {license,version}.txt $doc/

    mkdir -p $lib/lib
    cp api/lib/libBrainStem2.* $lib/lib

    mkdir -p $dev/include
    cp -R api/lib/BrainStem2 $dev/include/
  '';

  outputs = [ "out" "lib" "dev" "doc" ];

  meta = with lib; {
    description = "BrainStem Software Development Kit";
    longDescription = ''
      The BrainStem SDK provides a library to access and control Acroname smart
      USB switches, as well as a CLI interface, and a firmware updater.
    '';
    homepage = "https://acroname.com/software/brainstem-development-kit";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ flokli ];
    mainProgram = "AcronameHubCLI";
  };
}
