{
  stdenv,
  lib,
  unstick,
  unzip,
  fetchurl,
  withQuesta ? true,
  supportedDevices ? [
    "Arria II"
    "Cyclone V"
    "Cyclone IV"
    "Cyclone 10 LP"
    "MAX II/V"
    "MAX 10 FPGA"
  ],
  # leaves enabled: quartus, devinfo
  disabledComponents ? [
    "quartus_help"
    "quartus_update"
    "questa_fe"
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quartus-prime-lite-unwrapped";
  version = "25.1std.0.1129";

  nativeBuildInputs = [
    unstick
    # The devices' .qdz files are actually zip files, and without `unzip` here
    # they are failed to be extracted because the installer tries to run its
    # own `unzip` utility.
    unzip
  ];

  buildCommand = ''
    echo "setting up installer..."
  ''
  + lib.pipe finalAttrs.finalPackage.passthru.installers [
    (lib.mapAttrsToList finalAttrs.finalPackage.passthru.download)
    # NOTE that we don't have a choice but to `cp` the installers and not
    # symlink them, because the installers lookup for `.qdz` files by looking
    # at the directory of their real, symlink-resolved location. We can however
    # symlink the `.qdz` files to `$TEMP`.
    (map (installer: ''
      # `$(cat $NIX_CC/nix-support/dynamic-linker) $src[0]` often segfaults, so cp + patchelf
      cp ${installer} $TEMP/${installer.name}
      chmod u+w,+x $TEMP/${installer.name}
      patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $TEMP/${installer.name}
    ''))
    (lib.concatStringsSep "\n")
  ]
  + (
    let
      availableDevices = lib.pipe finalAttrs.finalPackage.passthru.deviceIds [
        lib.attrNames
        lib.naturalSort
      ];
      unsupportedRequestedDevices = lib.pipe supportedDevices [
        (lib.subtractLists availableDevices)
        lib.naturalSort
      ];
    in
    assert lib.assertMsg (unsupportedRequestedDevices == [ ]) ''
      Unsupported devices requested:
      ${lib.concatMapStringsSep "\n" (d: " - ${d}") unsupportedRequestedDevices}
      Supported devices are:
      ${lib.concatMapStringsSep "\n" (d: " - ${d}") availableDevices}
    '';
    lib.pipe supportedDevices [
      (map (name: finalAttrs.finalPackage.passthru.deviceIds.${name}))
      (ids: lib.getAttrs ids finalAttrs.finalPackage.passthru.components)
      (lib.mapAttrsToList (
        id: hash: finalAttrs.finalPackage.passthru.download "${id}-${finalAttrs.version}.qdz" hash
      ))
      # See NOTE above `map` that iterates the installers.
      (map (component: "ln -s ${component} $TEMP/${component.name}"))
      (lib.concatStringsSep "\n")
    ]
  )
  # New line preceding the below bash commands is required for the `echo` below
  # to be in its own line.
  + ''

    echo "executing installer..."
    # "Could not load seccomp program: Invalid argument" might occur if unstick
    # itself is compiled for x86_64 instead of the non-x86 host. In that case,
    # override the input.
    unstick $TEMP/${finalAttrs.finalPackage.passthru.mainInstaller} \
      --disable-components ${
        lib.concatStringsSep "," (
          disabledComponents
          ++ lib.optional (!withQuesta) "questa_fse"
          ++ lib.attrValues (lib.removeAttrs finalAttrs.finalPackage.passthru.deviceIds supportedDevices)
        )
      } \
      --mode unattended --installdir $out --accept_eula 1

    echo "installer log:"
    cat "$out/logs/quartus-${finalAttrs.version}-linux-install.log"

    echo "cleaning up..."
    rm -r $out/uninstall $out/logs

    # replace /proc pentium check with a true statement. this allows usage under emulation.
    substituteInPlace $out/quartus/adm/qenv.sh \
      --replace-fail 'grep sse /proc/cpuinfo > /dev/null 2>&1' ':'
  '';

  passthru = {
    deviceIds = {
      "Arria II" = "arria_lite";
      "Cyclone V" = "cyclonev";
      "Cyclone IV" = "cyclone";
      "Cyclone 10 LP" = "cyclone10lp";
      "MAX II/V" = "max";
      "MAX 10 FPGA" = "max10";
    };
    components = {
      "arria_lite" = "sha256-Epxvu1z7Z4vQWASIYEJAy5P7Meee114ZNVIAZnmTEH8=";
      "cyclone" = "sha256-lKOYy61BHxY4OyonxADg6d7IGwckGX8zu0x6dpGB5Lo=";
      "cyclone10lp" = "sha256-lurSlhCuE6i2ULKNFvlWNtk6rqdvVwREC607HbMSH2I=";
      "cyclonev" = "sha256-1uSE/RsKR3hbyLzTGOQn1Ml5j5J26e+SmFI1hl9ry28=";
      "max" = "sha256-jY/b906fJKgJOL3h5nWR5RQdvAJ3U9of6y4VopGo2z0=";
      "max10" = "sha256-gFeESwuRwrp+8rN7GYbRmOxPGDHMm+ClLRjl/rTBnOk=";
    };
    installers = {
      "QuartusLiteSetup-${finalAttrs.version}-linux.run" =
        "sha256-UYQz7H3NYXJVYK9lM1P3pcMgzOnlKLInR7io3zZ0xOs=";
    }
    // lib.optionalAttrs withQuesta {
      "QuestaSetup-${finalAttrs.version}-linux.run" =
        "sha256-0F7psE+jTimCoy+UVJRgxNC6GEVdY/PJu49hf+D7T3U=";
    };
    mainInstaller = "QuartusLiteSetup-${finalAttrs.version}-linux.run";
    # Make it a bit easier to override the download URL schema.
    baseURL = "https://downloads.intel.com/akdlm/software/acdsinst";
    # e.g. "23.1std.1.993" -> "23.1std/993"
    URLdir = "${lib.versions.majorMinor finalAttrs.version}std/${lib.elemAt (lib.splitVersion finalAttrs.version) 4}/ib_installers";
    download =
      name: hash:
      fetchurl {
        inherit name hash;
        url = "${finalAttrs.finalPackage.baseURL}/${finalAttrs.finalPackage.URLdir}/${name}";
      };
  };

  meta = {
    homepage = "https://fpgasoftware.intel.com";
    description = "FPGA design and simulation software";
    mainProgram = "quartus";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      bjornfor
      kwohlfahrt
      zainkergaye
      doronbehar
    ];
  };
})
