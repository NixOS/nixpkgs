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
    "arria_lite" = "0fg9mmncbb8vmmbc3hxgmrgvgfphn3k4glv7w2yjq66vz6nd8zql";
    "cyclone" = "1min1hjaw8ll0c1gvl6ihp7hczw36ag8l2yzgl6avcapcw53hgyp";
    "cyclone10lp" = "1kjjm11hjg0h6i7kilxvhmkay3v416bhwp0frg2bnwggpk29drxj";
    "cyclonev" = "10v928qhyfqw3lszhhcdishh1875k1bki9i0czx9252jprgd1g7g";
    "max" = "04sszzz3qnjziirisshhdqs7ks8mcvy15lc1mpp9sgm09pwlhgbb";
    "max10" = "0dqlq477zdx4pf5hlbkl1ycxiav19vx4sk6277cpxm8y1xz70972";
  };

  version = "23.1std.0.991";

  download = {name, sha256}: fetchurl {
    inherit name sha256;
    # e.g. "23.1std.0.991" -> "23.1std/921"
    url = "https://downloads.intel.com/akdlm/software/acdsinst/${lib.versions.majorMinor version}std/${lib.elemAt (lib.splitVersion version) 4}/ib_installers/${name}";
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "quartus-prime-lite-unwrapped";

  src = map download ([{
    name = "QuartusLiteSetup-${version}-linux.run";
    sha256 = "1mg4db56rg407kdsvpzys96z59bls8djyddfzxi6bdikcklxz98h";
  } {
    name = "QuestaSetup-${version}-linux.run";
    sha256 = "0f9lyphk4vf4ijif3kb4iqf18jl357z9h8g16kwnzaqwfngh2ixk";
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
    # leaves enabled: quartus, questa_fse, devinfo
    disabledComponents = [
      "quartus_help"
      "quartus_update"
      # not questa_fse
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
