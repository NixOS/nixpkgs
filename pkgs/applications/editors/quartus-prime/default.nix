{ lib, buildFHSEnv, callPackage, makeDesktopItem, writeScript, runtimeShell
, runCommand, quartus-prime-lite
, supportedDevices ? [ "Arria II" "Cyclone V" "Cyclone IV" "Cyclone 10 LP" "MAX II/V" "MAX 10 FPGA" ]
, unwrapped ? callPackage ./quartus.nix { inherit supportedDevices; }
}:

let
  desktopItem = makeDesktopItem {
    name = "quartus-prime-lite";
    exec = "quartus";
    icon = "quartus";
    desktopName = "Quartus";
    genericName = "Quartus Prime";
    categories = [ "Development" ];
  };
# I think modelsim_ase/linux/vlm checksums itself, so use FHSUserEnv instead of `patchelf`
in buildFHSEnv rec {
  name = "quartus-prime-lite"; # wrapped

  targetPkgs = pkgs: with pkgs; [
    (runCommand "ld-lsb-compat" {} ''
      mkdir -p "$out/lib"
      ln -sr "${glibc}/lib/ld-linux-x86-64.so.2" "$out/lib/ld-lsb-x86-64.so.3"
      ln -sr "${pkgsi686Linux.glibc}/lib/ld-linux.so.2" "$out/lib/ld-lsb.so.3"
    '')
    # quartus requirements
    glib
    xorg.libICE
    xorg.libSM
    zlib
    # qsys requirements
    xorg.libXtst
    xorg.libXi
  ];

  # Also support 32-bit executables.
  multiArch = true;

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
    libudev0-shim
    libxcrypt-legacy
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/128x128
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s ${unwrapped}/licenses/images/dc_quartus_panel_logo.png $out/share/icons/128x128/quartus.png

    progs_to_wrap=(
      "${unwrapped}"/quartus/bin/*
      "${unwrapped}"/quartus/sopc_builder/bin/qsys-{generate,edit,script}
      # Should we install all executables?
      "${unwrapped}"/modelsim_ase/bin/{vsim,vlog,vlib,vcom,vdel,vmap}
      "${unwrapped}"/modelsim_ase/linuxaloem/lmutil
    )

    wrapper=$out/bin/${name}
    progs_wrapped=()
    for prog in ''${progs_to_wrap[@]}; do
        relname="''${prog#"${unwrapped}/"}"
        wrapped="$out/$relname"
        progs_wrapped+=("$wrapped")
        mkdir -p "$(dirname "$wrapped")"
        echo "#!${runtimeShell}" >> "$wrapped"
        case "$relname" in
            modelsim_ase/*)
                echo "export NIXPKGS_IS_MODELSIM_WRAPPER=1" >> "$wrapped"
                ;;
        esac
        echo "$wrapper $prog \"\$@\"" >> "$wrapped"
    done

    cd $out
    chmod +x ''${progs_wrapped[@]}
    # link into $out/bin so executables become available on $PATH
    ln --symbolic --relative --target-directory ./bin ''${progs_wrapped[@]}
  '';

  profile = ''
    # LD_PRELOAD fixes issues in the licensing system that cause memory corruption and crashes when
    # starting most operations in many containerized environments, including WSL2, Docker, and LXC
    # (a similiar fix involving LD_PRELOADing tcmalloc did not solve the issue in my situation)
    # we use the name so that quartus can load the 64 bit verson and modelsim can load the 32 bit version
    # https://community.intel.com/t5/Intel-FPGA-Software-Installation/Running-Quartus-Prime-Standard-on-WSL-crashes-in-libudev-so/m-p/1189032
    #
    # But, as can be seen in the above resource, LD_PRELOADing libudev breaks
    # compiling encrypted device libraries in ModelSim (with error
    # `(vlog-2163) Macro `<protected> is undefined.`), so only use LD_PRELOAD
    # for non-ModelSim wrappers.
    if [ "$NIXPKGS_IS_MODELSIM_WRAPPER" != 1 ]; then
        export LD_PRELOAD=''${LD_PRELOAD:+$LD_PRELOAD:}libudev.so.0
    fi
  '';

  # Run the wrappers directly, instead of going via bash.
  runScript = "";

  passthru = {
    inherit unwrapped;
    tests = {
      modelsimEncryptedModel = runCommand "quartus-prime-lite-test-modelsim-encrypted-model" {} ''
        "${quartus-prime-lite}/bin/vlog" "${quartus-prime-lite.unwrapped}/modelsim_ase/altera/verilog/src/arriav_atoms_ncrypt.v"
        touch "$out"
      '';
    };
  };
}
