{ buildFHSUserEnv, makeDesktopItem, writeScript, stdenv, lib, requireFile, unstick,
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
    version = "20.1.0.711";
    pname = "quartus-prime-lite-unwrapped";

    src = let
      require = {name, sha256}: requireFile {
        inherit name sha256;
        url = "${meta.homepage}/${lib.versions.majorMinor version}/?edition=lite&platform=linux";
      };

      hashes = {
        "arria_lite" = "09g2knq23h3vj0s5y7hsdnqbbkr3pnv53dzpqcw2lq9mb5zfs9r0";
        "cyclonev" = "05hrpysasyfb7xhxg68spdffxyvxcx0iagibd5jz643b7n6aalpa";
        "cyclone" = "1x3rnwsvzrb5kwdz35sbcabxmcvj8xxpnjlpcjwfc69ybiyr6sgz";
        "cyclone10lp" = "1x6d4hm697mjgzaxixrw5va8anr6ihhx96x2524r6axpwqf6wcja";
        "max" = "060b7v0xh86kkjyiix7akfkzhx2kl1b3q117kp7xibnz6yrzwmy3";
        "max10" = "05840l9pmqa4i1b3ajfaxkqz1hppls556vbq16a42acz2qs2g578";
      };

      devicePackages = map (id: {
        name = "${id}-${version}.qdz";
        sha256 = lib.getAttr id hashes;
      }) (lib.attrValues supportedDeviceIds);
    in map require ([{
      name = "QuartusLiteSetup-${version}-linux.run";
      sha256 = "07ssrv8p8kacal6xd80n4h7l5xz13aw1m1gfqqaxig0ivsj971z5";
    } {
      name = "ModelSimSetup-${version}-linux.run";
      sha256 = "0smxasrmr1c8k6hy378knskpjmz4cgpgb35v5jclns0kx68y3c42";
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
    name = "quartus-prime-lite";
    exec = "quartus";
    icon = "quartus";
    desktopName = "Quartus";
    genericName = "Quartus Prime";
    categories = "Development;";
  };

# I think modelsim_ase/linux/vlm checksums itself, so use FHSUserEnv instead of `patchelf`
in buildFHSUserEnv rec {
  name = "quartus-prime-lite"; # wrapped

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

  passthru = {
    unwrapped = quartus;
  };

  extraInstallCommands = let
    quartusExecutables = (map (c: "quartus/bin/quartus_${c}") [
      "asm" "cdb" "cpf" "drc" "eda" "fit" "jbcc" "jli" "map" "pgm" "pow"
      "sh" "si" "sim" "sta" "stp" "tan"
    ]) ++ [ "quartus/bin/quartus" ];

    qsysExecutables = map (c: "quartus/sopc_builder/bin/qsys-${c}") [
      "generate" "edit" "script"
    ];
    # Should we install all executables ?
    modelsimExecutables = map (c: "modelsim_ase/bin/${c}") [
      "vsim" "vlog" "vlib"
    ];
  in ''
    mkdir -p $out/share/applications $out/share/icons/128x128
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s ${quartus}/licenses/images/dc_quartus_panel_logo.png $out/share/icons/128x128/quartus.png

    mkdir -p $out/quartus/bin $out/quartus/sopc_builder/bin $out/modelsim_ase/bin
    WRAPPER=$out/bin/${name}
    EXECUTABLES="${lib.concatStringsSep " " (quartusExecutables ++ qsysExecutables ++ modelsimExecutables)}"
    for executable in $EXECUTABLES; do
        echo "#!${stdenv.shell}" >> $out/$executable
        echo "$WRAPPER ${quartus}/$executable \$@" >> $out/$executable
    done

    cd $out
    chmod +x $EXECUTABLES
    # link into $out/bin so executables become available on $PATH
    ln --symbolic --relative --target-directory ./bin $EXECUTABLES
  '';

  runScript = writeScript "${name}-wrapper" ''
    exec $@
  '';
}
