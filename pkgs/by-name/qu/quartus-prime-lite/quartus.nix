{
  stdenv,
  lib,
  unstick,
  unzip,
  requireFile,
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
  src =
    let
      availableDevices = lib.pipe finalAttrs.finalPackage.passthru.deviceIds [
        lib.attrNames
        lib.naturalSort
      ];
      unsupportedRequestedDevices = lib.pipe supportedDevices [
        (lib.subtractLists availableDevices)
        lib.naturalSort
      ];
      name = "Quartus-lite-${finalAttrs.version}-linux.tar";
    in
    assert lib.assertMsg (unsupportedRequestedDevices == [ ]) ''
      Unsupported devices requested:
      ${lib.concatMapStringsSep "\n" (d: " - ${d}") unsupportedRequestedDevices}
      Supported devices are:
      ${lib.concatMapStringsSep "\n" (d: " - ${d}") availableDevices}
    '';
    requireFile {
      inherit name;
      url = "${finalAttrs.finalPackage.baseURL}/${finalAttrs.finalPackage.URLdir}/${name}";
      hash = "sha256-FSFYsLRmML+ZrLNwd04SpniYIABRGdJ0tLj7XkPcx0k=";
    };

  # `src` is roughly 8.9GB, so sending it over to a remote builder and then
  # downloading the result back doesn't make sense. Also building this
  # derivation doesn't even consist of any compilation that can benefit from a
  # remote builder's potentially faster performence.
  preferLocalBuild = true;

  nativeBuildInputs = [
    unstick
    # The devices' .qdz files are actually zip files, and without `unzip` here
    # they are failed to be extracted because the installer tries to run its
    # own `unzip` utility.
    unzip
  ];

  buildPhase = ''
    echo "setting up installer..."
    patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) *.run
    echo "executing installer..."
    # "Could not load seccomp program: Invalid argument" might occur if unstick
    # itself is compiled for x86_64 instead of the non-x86 host. In that case,
    # override the input.
    unstick ./${finalAttrs.finalPackage.passthru.mainInstaller} \
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
    mainInstaller = "QuartusLiteSetup-${finalAttrs.version}-linux.run";
    # Make it a bit easier to override the download URL schema.
    baseURL = "https://downloads.intel.com/akdlm/software/acdsinst";
    # e.g. "23.1std.1.993" -> "23.1std/993"
    URLdir = "${lib.versions.majorMinor finalAttrs.version}std/${lib.elemAt (lib.splitVersion finalAttrs.version) 4}/ib_tar";
  };

  meta = {
    homepage = "https://www.altera.com/downloads/fpga-development-tools/quartus-prime-lite-current";
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
