{ buildFHSUserEnv, makeDesktopItem, stdenv, lib, requireFile, unstick,
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

  quartus = stdenv.mkDerivation rec {
    version = "19.1.0.670";
    pname = "quartus-prime-lite";

    src = let
      require = {name, sha256}: requireFile {
        inherit name sha256;
        url = "${meta.homepage}/${lib.versions.majorMinor version}/?edition=lite&platform=linux";
      };

      hashes = {
        "arria_lite" = "1flj9w0vb2p9f9zll136izr6qvmxn0lg72bvaqxs3sxc9vj06wm1";
        "cyclonev" = "0bqxpvjgph0y6slk0jq75mcqzglmqkm0jsx10y9xz5llm6zxzqab";
        "cyclone" = "0pzs8y4s3snxg4g6lrb21qi88abm48g279xzd98qv17qxb2z82rr";
        "cyclone10lp" = "1ccxq8n20y40y47zddkijcv41w3cddvydddr3m4844q31in3nxha";
        "max" = "1cxzbqscxvlcy74dpqmvlnxjyyxfwcx3spygpvpwi6dfj3ipgm2z";
        "max10" = "14k83javivbk65mpb17wdwsyb8xk7x9gzj9x0wnd24mmijrvdy9s";
      };

      devicePackages = map (id: {
        name = "${id}-${version}.qdz";
        sha256 = lib.getAttr id hashes;
      }) (lib.attrValues supportedDeviceIds);
    in map require ([{
      name = "QuartusLiteSetup-${version}-linux.run";
      sha256 = "15vxvqxqdk29ahlw3lkm1nzxyhzy4626wb9s5f2h6sjgq64r8m7f";
    } {
      name = "ModelSimSetup-${version}-linux.run";
      sha256 = "0j1vfr91jclv88nam2plx68arxmz4g50sqb840i60wqd5b0l3y6r";
    }] ++ devicePackages);

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

    # This patch is from https://wiki.archlinux.org/index.php/Altera_Design_Software
    patch --force --strip 0 --directory $out < ${./vsim.patch}

    rm -r $out/uninstall $out/logs
  '';

    meta = {
      homepage = "https://fpgasoftware.intel.com";
      description = "FPGA design and simulation software";
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ kwohlfahrt ];
    };
  };

  desktopItem = makeDesktopItem {
    name = quartus.name;
    exec = "quartus";
    icon = "quartus";
    desktopName = "Quartus";
    genericName = "Quartus FPGA IDE";
    categories = "Development;";
  };

# I think modelsim_ase/linux/vlm checksums itself, so use FHSUserEnv instead of `patchelf`
in buildFHSUserEnv {
  name = "quartus-prime-lite";

  targetPkgs = pkgs: with pkgs; [
    # quartus requirements
    glib
    xorg.libICE
    xorg.libSM
    zlib
    # qsys requirements
    xorg.libXtst
    xorg.libXi
  ];
  multiPkgs = pkgs: with pkgs; let
    # This seems ugly - can we override `libpng = libpng12` for all `pkgs`?
    freetype = pkgs.freetype.override { libpng = libpng12; };
    fontconfig = pkgs.fontconfig.override { inherit freetype; };
    libXft = pkgs.xorg.libXft.override { inherit freetype fontconfig; };
  in [
    # modelsim requirements
    libxml2
    ncurses5
    unixODBC
    libXft
    # common requirements
    freetype
    fontconfig
    xorg.libX11
    xorg.libXext
    xorg.libXrender
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  runScript = "${quartus}/quartus/bin/quartus";
}
