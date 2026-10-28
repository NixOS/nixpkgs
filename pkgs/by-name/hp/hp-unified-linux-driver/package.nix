{
  lib,
  stdenv,
  cups,
  libusb1,
  libxml2_13, # The uld library uses libxml2.so.2 which is provided only in the older version
  fetchurl,
  patchPpdFilesHook,
  buildPackages,
  replaceVars,
}:

let
  version = "1.00.39.12_00.15";
  installationPath =
    {
      x86_64-linux = "x86_64";
      i686-linux = "i386";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  unpacked = stdenv.mkDerivation (finalAttrs: {
    inherit version;
    pname = "hp-unified-linux-driver-unpacked";

    src = fetchurl {
      url = "https://ftp.hp.com/pub/softlib/software13/printers/MFP170/uld-hp_V${version}.tar.gz";
      hash = "sha256-zrube2El50BmNLucKpiwFHfR4R1mx8kEdGad6ZJ7yR0=";
    };
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/opt/smfp-common/scanner/.usedby/
      cp -r . $out
    '';
  });

  patchedWrapper = replaceVars ./libsane-smfp-wrapper.c {
    libsane_smfp_cfg_to = "${unpacked}/noarch/libsane-smfp.cfg";
    smfp_conf_to = "${unpacked}/noarch/etc/smfp.conf";
    usedby_to = "${unpacked}/opt/smfp-common/scanner/.usedby/";
    oem_to = "${unpacked}/noarch/oem.conf";
    sane_d_to = "${unpacked}/etc/sane.d";
    opt_to = "${unpacked}/opt";
  };

  # Contains a fopen() wrapper
  wrapperLibName = "libsane-smfp-wrapper.so";
  wrapperLib = stdenv.mkDerivation (finalAttrs: {
    pname = "libsane-smfp-wrapper-lib";
    inherit version;

    unpackPhase = ''
      cp ${patchedWrapper} libsane-smfp-wrapper.c
    '';

    buildPhase = ''
      $CC -fPIC -shared libsane-smfp-wrapper.c -o ${wrapperLibName}
    '';

    installPhase = ''
      install -D ${wrapperLibName} -t $out/lib
    '';
  });

  libPath =
    lib.makeLibraryPath [
      cups
      libusb1
      libxml2_13
      wrapperLib
    ]
    + ":$out/lib:${lib.getLib stdenv.cc.cc}/lib";
in
stdenv.mkDerivation {
  inherit version;

  pname = "hp-unified-linux-driver";
  src = unpacked;

  nativeBuildInputs = [ patchPpdFilesHook ];

  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/smfp-common/scanner/.usedby/
    mkdir -p $out/share/cups
    mkdir -p $out/etc/sane.d/dll.d
    mkdir -p $out/lib/udev/rules.d

    install -m755 ${installationPath}/{pstosecps,rastertospl,smfpnetdiscovery}  -D -t $out/lib/cups/filter/
    install -m755 ${installationPath}/libscmssc.so -D -t $out/lib/
    install -m755 ${installationPath}/libsane-smfp.so.1.0.1 -D -t $out/lib/sane/
    install -m644 noarch/etc/smfp.conf -D -t $out/etc/sane.d/
    cp -r noarch/share/ppd $out/share/

    echo "smfp" >> $out/etc/sane.d/dll.d/hp-uld.conf

    ln -s $out/share/ppd $out/share/cups/model
    ln -sf $out/lib/sane/libsane-smfp.so.1.0.1 $out/lib/sane/libsane-smfp.so.1
    ln -sf $out/lib/sane/libsane-smfp.so.1 $out/lib/sane/libsane-smfp.so

    (
      OEM_FILE=noarch/oem.conf
      INSTALL_LOG_FILE=/dev/null
      . noarch/scripting_utils
      . noarch/package_utils
      . noarch/scanner-script.pkg
      fill_full_template noarch/etc/smfp.rules.in $out/lib/udev/rules.d/60_smfp_hp.rules
      chmod -x $out/lib/udev/rules.d/60_smfp_hp.rules
    )

    runHook postInstall
  '';

  postFixup = ''
    patchelf --set-rpath ${libPath} --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/lib/cups/filter/{pstosecps,rastertospl,smfpnetdiscovery}

    echo fopen fopen_wrapper >> name_map
    echo opendir opendir_wrapper >> name_map
    ${buildPackages.patchelfUnstable}/bin/patchelf \
      --rename-dynamic-symbols name_map \
      --add-needed ${wrapperLibName} \
      --set-rpath ${libPath} \
      $out/lib/sane/libsane-smfp.so.1.0.1

    patchelf --set-rpath ${libPath} $out/lib/libscmssc.so
  '';

  ppdFileCommands = [
    "pstosecps"
    "rastertospl"
    "smfpnetdiscovery"
  ];

  meta = {
    description = "Drivers for HP printers that are actually Samsung printers";
    homepage = "http://www.hp.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [ danberdev ];
  };
}
