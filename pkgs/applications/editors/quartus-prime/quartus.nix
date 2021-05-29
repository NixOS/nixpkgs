{ stdenv, lib, unstick, requireFile,
  supportedDevices ? [ "Arria II" "Cyclone V" "Cyclone IV" "Cyclone 10 LP" "MAX II/V" "MAX 10 FPGA" ] }:

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
    "arria_lite" = "09g2knq23h3vj0s5y7hsdnqbbkr3pnv53dzpqcw2lq9mb5zfs9r0";
    "cyclonev" = "05hrpysasyfb7xhxg68spdffxyvxcx0iagibd5jz643b7n6aalpa";
    "cyclone" = "1x3rnwsvzrb5kwdz35sbcabxmcvj8xxpnjlpcjwfc69ybiyr6sgz";
    "cyclone10lp" = "1x6d4hm697mjgzaxixrw5va8anr6ihhx96x2524r6axpwqf6wcja";
    "max" = "060b7v0xh86kkjyiix7akfkzhx2kl1b3q117kp7xibnz6yrzwmy3";
    "max10" = "05840l9pmqa4i1b3ajfaxkqz1hppls556vbq16a42acz2qs2g578";
  };

  version = "20.1.0.711";
  homepage = "https://fpgasoftware.intel.com";

  require = {name, sha256}: requireFile {
    inherit name sha256;
    url = "${homepage}/${lib.versions.majorMinor version}/?edition=lite&platform=linux";
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "quartus-prime-lite-unwrapped";

  src = map require ([{
    name = "QuartusLiteSetup-${version}-linux.run";
    sha256 = "07ssrv8p8kacal6xd80n4h7l5xz13aw1m1gfqqaxig0ivsj971z5";
  } {
    name = "ModelSimSetup-${version}-linux.run";
    sha256 = "0smxasrmr1c8k6hy378knskpjmz4cgpgb35v5jclns0kx68y3c42";
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
      "modelsim_ae"
    ] ++ (lib.attrValues unsupportedDeviceIds);
  in ''
      ${lib.concatMapStringsSep "\n" copyInstaller installers}
      ${lib.concatMapStringsSep "\n" copyComponent components}

      unstick $TEMP/${(builtins.head installers).name} \
        --disable-components ${lib.concatStringsSep "," disabledComponents} \
        --mode unattended --installdir $out --accept_eula 1

      rm -r $out/uninstall $out/logs
    '';

  meta = {
    inherit homepage;
    description = "FPGA design and simulation software";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ]; # requireFile srcs cannot be fetched by hydra, ignore
    maintainers = with lib.maintainers; [ kwohlfahrt ];
  };
}
