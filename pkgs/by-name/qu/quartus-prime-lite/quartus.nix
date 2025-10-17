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
    "arria_lite" = "sha256-ASvi9YX15b4XXabGjkuR5wl9wDwCijl8s750XTR/4XU=";
    "cyclone" = "sha256-iNA4S5mssffgn29NUhibJk6iKnmJ+vG9LYY3W+nnqcI=";
    "cyclone10lp" = "sha256-247yR2fm5A3LWRjePJU99z1NBYziV8WkPL05wHJ4Z1Q=";
    "cyclonev" = "sha256-Fa1PQ3pp9iTPYQljeKGyxHIXHaSolJZR8vXVb3gEN7g=";
    "max" = "sha256-lAA1CgSfAjfilLDhRzfU2OkzGAChk7TMFckeboMB4mI=";
    "max10" = "sha256-edycBj0P3qwLN2YS//QpCHQeGOW8WM0RqTIWdGAkEv8=";
  };

  version = "24.1std.0.1077";

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
        sha256 = "sha256-NFWT1VWcb3gun7GhpPbHzR3SIYBMpK40jESXS/vC5II=";
      }
    ]
    ++ lib.optional withQuesta {
      name = "QuestaSetup-${version}-linux.run";
      sha256 = "sha256-4+Y34UiJwenlIp/XKzMs+2aYZt/Y6XmNmiYyXVmOQkc=";
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
      zainkergaye
    ];
  };
}
