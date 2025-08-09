{
  stdenv,
  lib,
  unstick,
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
    assert lib.assertMsg (lib.all (
      name: lib.hasAttr name deviceIds
    ) supportedDevices) "Supported devices are: ${lib.concatStringsSep ", " (lib.attrNames deviceIds)}";
    lib.listToAttrs (
      map (name: {
        inherit name;
        value = deviceIds.${name};
      }) supportedDevices
    );

  unsupportedDeviceIds = lib.filterAttrs (
    name: value: !(lib.hasAttr name supportedDeviceIds)
  ) deviceIds;

  componentHashes = {
    "arria_lite" = "sha256-PNoc15Y5h+2bxhYFIxkg1qVAsXIX3IMfEQSdPLVNUp4=";
    "cyclone" = "sha256-2huDuTkXt6jszwih0wzusoxRvECi6+tupvRcUvn6eIA=";
    "cyclone10lp" = "sha256-i8VJKqlIfQmK2GWhm0W0FujHcup4RjeXughL2VG5gkY=";
    "cyclonev" = "sha256-HoNJkcD96rPQEZtjbtmiRpoKh8oni7gOLVi80c1a3TM=";
    "max" = "sha256-qh920mvu0H+fUuSJBH7fDPywzll6sGdmEtfx32ApCSA=";
    "max10" = "sha256-XOyreAG3lYEV7Mnyh/UnFTuOwPQsd/t23Q8/P2p6U+0=";
  };

  version = "23.1std.1.993";

  download =
    { name, sha256 }:
    fetchurl {
      inherit name sha256;
      # e.g. "23.1std.1.993" -> "23.1std/993"
      url = "https://downloads.intel.com/akdlm/software/acdsinst/${lib.versions.majorMinor version}std/${lib.elemAt (lib.splitVersion version) 4}/ib_installers/${name}";
    };

  installers = map download (
    [
      {
        name = "QuartusLiteSetup-${version}-linux.run";
        sha256 = "sha256-OCp2hZrfrfp1nASuVNWgg8/ODRrl67SJ+c6IWq5eWvY=";
      }
    ]
    ++ lib.optional withQuesta {
      name = "QuestaSetup-${version}-linux.run";
      sha256 = "sha256-Dne4MLFSGXUVLMd+JgiS/d5RX9t5gs6PEvexTssLdF4=";
    }
  );
  components = map (
    id:
    download {
      name = "${id}-${version}.qdz";
      sha256 = lib.getAttr id componentHashes;
    }
  ) (lib.attrValues supportedDeviceIds);

in
stdenv.mkDerivation {
  inherit version;
  pname = "quartus-prime-lite-unwrapped";

  nativeBuildInputs = [ unstick ];

  buildCommand =
    let
      copyInstaller = installer: ''
        # `$(cat $NIX_CC/nix-support/dynamic-linker) $src[0]` often segfaults, so cp + patchelf
        cp ${installer} $TEMP/${installer.name}
        chmod u+w,+x $TEMP/${installer.name}
        patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $TEMP/${installer.name}
      '';
      copyComponent = component: "cp ${component} $TEMP/${component.name}";
      # leaves enabled: quartus, devinfo
      disabledComponents = [
        "quartus_help"
        "quartus_update"
        "questa_fe"
      ]
      ++ (lib.optional (!withQuesta) "questa_fse")
      ++ (lib.attrValues unsupportedDeviceIds);
    in
    ''
      echo "setting up installer..."
      ${lib.concatMapStringsSep "\n" copyInstaller installers}
      ${lib.concatMapStringsSep "\n" copyComponent components}

      echo "executing installer..."
      # "Could not load seccomp program: Invalid argument" might occur if unstick
      # itself is compiled for x86_64 instead of the non-x86 host. In that case,
      # override the input.
      unstick $TEMP/${(builtins.head installers).name} \
        --disable-components ${lib.concatStringsSep "," disabledComponents} \
        --mode unattended --installdir $out --accept_eula 1

      echo "cleaning up..."
      rm -r $out/uninstall $out/logs

      # replace /proc pentium check with a true statement. this allows usage under emulation.
      substituteInPlace $out/quartus/adm/qenv.sh \
        --replace-fail 'grep sse /proc/cpuinfo > /dev/null 2>&1' ':'
    '';

  meta = with lib; {
    homepage = "https://fpgasoftware.intel.com";
    description = "FPGA design and simulation software";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
      bjornfor
      kwohlfahrt
    ];
  };
}
