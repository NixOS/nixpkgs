{ stdenv, lib, unstick, fetchurl
, supportedDevices ? [ "Arria II" "Cyclone V" "Cyclone IV" "Cyclone 10 LP" "MAX II/V" "MAX 10 FPGA" ]
}:

let
  deviceIds = {
    "Arria II" = "arria_lite";
    "Cyclone V" = "cyclonev";
    "Cyclone IV" = "cyclone";
    "Cyclone 10 LP" = "cyclone10lp";
    "MAX II/V" = "max";
    "MAX 10 FPGA" = "max10";
  };

  supportedDeviceIds =
    assert lib.assertMsg (lib.all (name: lib.hasAttr name deviceIds) supportedDevices)
      "Supported devices are: ${lib.concatStringsSep ", " (lib.attrNames deviceIds)}";
    lib.listToAttrs (map (name: {
      inherit name;
      value = deviceIds.${name};
    }) supportedDevices);

  unsupportedDeviceIds = lib.filterAttrs (name: value:
    !(lib.hasAttr name supportedDeviceIds)
  ) deviceIds;

  componentHashes = {
    "arria_lite" = "0bnxi43b6cbaw3fn461ggbgqww9sxyki7h5wmlm3nvbj6iwfbqf2";
    "cyclone" = "04n128gyjzax90d16bc5qmjgb2wbp9vvqkgm2wd84fm9dci6jgds";
    "cyclone10lp" = "0w82vwspw02kyf4gp4w46q27ff2nkhlp8v7whi4qm4136rn55zlh";
    "cyclonev" = "0xgl9g7p491vbv39km97qp66rzfgfxsax4sf437hnkv3395bal4i";
    "max" = "06n2m92hsspzkdm47i3wg87h92g0smzchfm2mb5adqvins3wvj42";
    "max10" = "04q1nks44rrhxlzshh68hdlbxza3n8b4v0dbf5ngzyl909qgkzla";
  };

  version = "22.1std.0.915";
  urlFirst = "22.1std";
  urlSecond = "915";

  download = {name, sha256}: fetchurl {
    inherit name sha256;
    # e.g. "20.1.1.720" -> "20.1std.1/720"
    url = "https://downloads.intel.com/akdlm/software/acdsinst/${urlFirst}/${urlSecond}/ib_installers/${name}";
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "quartus-prime-lite-unwrapped";

  src = map download ([{
    name = "QuartusLiteSetup-${version}-linux.run";
    sha256 = "0h46s1d5dncmkrpjynqf3l4x7m6ch3d99lyh91sxgqg97ljrx9hl";
  } {
    name = "QuestaSetup-${version}-linux.run";
    sha256 = "1aqlh4xif96phmsp8ll73bn9nrd6zakhsf4c0cbc44j80fjwj6qx";
  }] ++ (map (id: {
    name = "${id}-${version}.qdz";
    sha256 = lib.getAttr id componentHashes;
  }) (lib.attrValues supportedDeviceIds)));

  nativeBuildInputs = [ unstick ];

  buildCommand = let
    installers = lib.sublist 0 2 src;
    components = lib.sublist 2 ((lib.length src) - 2) src;
    copyInstaller = installer: ''
        # `$(cat $NIX_CC/nix-support/dynamic-linker) $src[0]` often segfaults, so cp + patchelf
        cp ${installer} $TEMP/${installer.name}
        chmod u+w,+x $TEMP/${installer.name}
        patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $TEMP/${installer.name}
      '';
    copyComponent = component: "cp ${component} $TEMP/${component.name}";
    # leaves enabled: quartus, modelsim_ase, devinfo
    disabledComponents = [
      "quartus_help"
      "quartus_update"
      # not modelsim_ase
      "questa_fe"
    ] ++ (lib.attrValues unsupportedDeviceIds);
  in ''
      ${lib.concatMapStringsSep "\n" copyInstaller installers}
      ${lib.concatMapStringsSep "\n" copyComponent components}

      unstick $TEMP/${(builtins.head installers).name} \
        --disable-components ${lib.concatStringsSep "," disabledComponents} \
        --mode unattended --installdir $out --accept_eula 1

      rm -r $out/uninstall $out/logs
    '';

  meta = with lib; {
    homepage = "https://fpgasoftware.intel.com";
    description = "FPGA design and simulation software";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ kwohlfahrt ];
  };
}
