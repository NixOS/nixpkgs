{ lib, buildFHSEnv, callPackage, makeDesktopItem, runtimeShell
, runCommand, unstick, quartus-prime-lite, libfaketime, pkgsi686Linux
, withQuesta ? true
, supportedDevices ? [ "Arria II" "Cyclone V" "Cyclone IV" "Cyclone 10 LP" "MAX II/V" "MAX 10 FPGA" ]
, unwrapped ? callPackage ./quartus.nix { inherit unstick supportedDevices withQuesta; }
, extraProfile ? ""
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
# I think questa_fse/linux/vlm checksums itself, so use FHSUserEnv instead of `patchelf`
in buildFHSEnv rec {
  pname = "quartus-prime-lite"; # wrapped
  inherit (unwrapped) version;

  targetPkgs = pkgs: with pkgs; [
    (runCommand "ld-lsb-compat" {} (''
      mkdir -p "$out/lib"
      ln -sr "${glibc}/lib/ld-linux-x86-64.so.2" "$out/lib/ld-lsb-x86-64.so.3"
    '' + lib.optionalString withQuesta ''
      ln -sr "${pkgsi686Linux.glibc}/lib/ld-linux.so.2" "$out/lib/ld-lsb.so.3"
    ''))
    # quartus requirements
    glib
    xorg.libICE
    xorg.libSM
    xorg.libXau
    xorg.libXdmcp
    libudev0-shim
    bzip2
    brotli
    expat
    dbus
    # qsys requirements
    xorg.libXtst
    xorg.libXi
    dejavu_fonts
    gnumake
  ];

  # Also support 32-bit executables used by simulator.
  multiArch = withQuesta;

  # these libs are installed as 64 bit, plus as 32 bit when multiArch is true
  multiPkgs = pkgs: with pkgs; let
    # This seems ugly - can we override `libpng = libpng12` for all `pkgs`?
    freetype = pkgs.freetype.override { libpng = libpng12; };
    fontconfig = pkgs.fontconfig.override { inherit freetype; };
    libXft = pkgs.xorg.libXft.override { inherit freetype fontconfig; };
  in [
    # questa requirements
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
    libxcrypt-legacy
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/64x64/apps
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    ln -s ${unwrapped}/quartus/adm/quartusii.png $out/share/icons/hicolor/64x64/apps/quartus.png

    progs_to_wrap=(
      "${unwrapped}"/quartus/bin/*
      "${unwrapped}"/quartus/sopc_builder/bin/qsys-{generate,edit,script}
      "${unwrapped}"/questa_fse/bin/*
      "${unwrapped}"/questa_fse/linux_x86_64/lmutil
    )

    wrapper=$out/bin/${pname}
    progs_wrapped=()
    for prog in ''${progs_to_wrap[@]}; do
        relname="''${prog#"${unwrapped}/"}"
        bname="$(basename "$relname")"
        wrapped="$out/$relname"
        progs_wrapped+=("$wrapped")
        mkdir -p "$(dirname "$wrapped")"
        echo "#!${runtimeShell}" >> "$wrapped"
        NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK=1
        case "$relname" in
            questa_fse/*)
                echo "export NIXPKGS_IS_QUESTA_WRAPPER=1" >> "$wrapped"
                # Any use of LD_PRELOAD breaks Questa, so disable the
                # SOURCE_DATE_EPOCH code path.
                NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK=0
                ;;
        esac
        # SOURCE_DATE_EPOCH blocklist for programs that are known to hang/break
        # with fixed/static clock.
        case "$bname" in
            jtagd|quartus_pgm|quartus)
                NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK=0
                ;;
        esac
        echo "export NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK=$NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK" >> "$wrapped"
        echo "exec $wrapper $prog \"\$@\"" >> "$wrapped"
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
    # https://community.intel.com/t5/Intel-FPGA-Software-Installation/Running-Quartus-Prime-Standard-on-WSL-crashes-in-libudev-so/m-p/1189032
    #
    # But, as can be seen in the above resource, LD_PRELOADing libudev breaks
    # compiling encrypted device libraries in Questa (with error
    # `(vlog-2163) Macro `<protected> is undefined.`), so only use LD_PRELOAD
    # for non-Questa wrappers.
    if [ "$NIXPKGS_IS_QUESTA_WRAPPER" != 1 ]; then
        export LD_PRELOAD=''${LD_PRELOAD:+$LD_PRELOAD:}/usr/lib/libudev.so.0
    fi

    # Implement the SOURCE_DATE_EPOCH specification for reproducible builds
    # (https://reproducible-builds.org/specs/source-date-epoch).
    # Require opt-in with NIXPKGS_QUARTUS_REPRODUCIBLE_BUILD=1 for now, in case
    # the blocklist is incomplete.
    if [ -n "$SOURCE_DATE_EPOCH" ] && [ "$NIXPKGS_QUARTUS_REPRODUCIBLE_BUILD" = 1 ] && [ "$NIXPKGS_QUARTUS_THIS_PROG_SUPPORTS_FIXED_CLOCK" = 1 ]; then
        export LD_LIBRARY_PATH="${lib.makeLibraryPath [ libfaketime pkgsi686Linux.libfaketime ]}''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        export LD_PRELOAD=libfaketime.so.1''${LD_PRELOAD:+:$LD_PRELOAD}
        export FAKETIME_FMT="%s"
        export FAKETIME="$SOURCE_DATE_EPOCH"
    fi
  '' + extraProfile;

  # Run the wrappers directly, instead of going via bash.
  runScript = "";

  passthru = {
    inherit unwrapped;
    tests = {
      buildSof = runCommand "quartus-prime-lite-test-build-sof"
        { nativeBuildInputs = [ quartus-prime-lite ];
          env.NIXPKGS_QUARTUS_REPRODUCIBLE_BUILD = "1";
        }
        ''
          cat >mydesign.vhd <<EOF
          library ieee;
          use ieee.std_logic_1164.all;

          entity mydesign is
          port (
              in_0: in std_logic;
              in_1: in std_logic;
              out_1: out std_logic
          );
          end mydesign;

          architecture dataflow of mydesign is
          begin
              out_1 <= in_0 and in_1;
          end dataflow;
          EOF

          quartus_sh --flow compile mydesign

          if ! [ -f mydesign.sof ]; then
              echo "error: failed to produce mydesign.sof" >&2
              exit 1
          fi

          sha1sum mydesign.sof > "$out"
        '';
        questaEncryptedModel = runCommand "quartus-prime-lite-test-questa-encrypted-model"
          { env.NIXPKGS_QUARTUS_REPRODUCIBLE_BUILD = "1";
          }
          ''
            "${quartus-prime-lite}/bin/vlog" "${quartus-prime-lite.unwrapped}/questa_fse/intel/verilog/src/arriav_atoms_ncrypt.v"
            touch "$out"
          '';
    };
  };

  inherit (unwrapped) meta;
}
