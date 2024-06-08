{ stdenv
, buildFHSEnv
, fetchurl
, fetchzip
, lib
, zlib
, gdbm
, libxslt
, libxml2
, libuuid
, readline
, readline70
, xz
, cups
, glibc
, libaio
, vulkan-loader
, alsa-lib
, libpulseaudio
, libxcrypt-legacy
, libGL
, numactl
, libX11
, libXi
, kmod
, python3
, autoPatchelfHook
, makeWrapper
, symlinkJoin
, enableInstaller ? false, bzip2, sqlite
, enableMacOSGuests ? false, fetchFromGitHub, unzip
, enableGuestTools ? true,
}:

let
  # base - versions
  version = "17.5.2";
  build = "23775571";
  baseUrl = "https://softwareupdate.vmware.com/cds/vmw-desktop/ws/${version}/${build}/linux";

  # tools - versions
  toolsVersion = "12.4.0";
  toolsBuild = "23259341";

  # macOS - versions
  fusionVersion = "13.5.2";
  fusionBuild = "23775688";
  unlockerVersion = "3.0.5";

  guestToolsSrc =
  let
    fetchComponent = (system: hash: fetchzip {
      inherit hash;
      url = "${baseUrl}/packages/vmware-tools-${system}-${toolsVersion}-${toolsBuild}.x86_64.component.tar";
      stripRoot = false;
    } + "/vmware-tools-${system}-${toolsVersion}-${toolsBuild}.x86_64.component");
  in lib.mapAttrsToList fetchComponent {
      linux = "sha256-vT08mR6cCXZjiQgb9jy+MaqYzS0hFbNUM7xGAHIJ8Ao=";
      linuxPreGlibc25 = "sha256-BodN1lxuhxyLlxIQSlVhGKItJ10VPlti/sEyxcRF2SA=";
      netware = "sha256-o/S4wAYLR782Fn20fTQ871+rzsa1twnAxb9laV16XIk=";
      solaris = "sha256-3LdFoI4TD5zxlohDGR3DRGbF6jwDZAoSMEpHWU4vSGU=";
      winPre2k = "sha256-+QcvWfY3aCDxUwAfSuj7Wf9sxIO+ztWBrRolMim8Dfw=";
      winPreVista = "sha256-3NgO/GdRFTpKNo45TMet0msjzxduuoF4nVLtnOUTHUA=";
      windows = "sha256-2F7UPjNvtibmWAJxpB8IOnol12aMOGMy+403WeCTXw8=";
  };

  # macOS - ISOs
  darwinIsoSrc = fetchzip {
    url = "https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/${fusionVersion}/${fusionBuild}/universal/core/com.vmware.fusion.zip.tar";
    sha256 = "sha256-DDLRWAVRI3ZeXV5bUXWwput9mEC1qsJUsjojI0CJYMI=";
    stripRoot = false;
  } + "/com.vmware.fusion.zip";

  # macOS - Unlocker
  unlockerSrc = fetchFromGitHub {
    owner = "paolo-projects";
    repo = "unlocker";
    rev = "${unlockerVersion}";
    sha256 = "sha256-JSEW1gqQuLGRkathlwZU/TnG6dL/xWKW4//SfE+kO0A=";
  };

  gdbm3 = gdbm.overrideAttrs (old: rec {
    version = "1.8.3";

    src = fetchurl {
      url = "mirror://gnu/gdbm/gdbm-${version}.tar.gz";
      sha256 = "sha256-zDQDOKLii0AFirnrU1SiHVP4ihWC6iG6C7GFw3ooHck=";
    };

    installPhase = ''
      mkdir -p $out/lib
      cp .libs/libgdbm*.so* $out/lib/
    '';
  });

  vmware-unpack-env = buildFHSEnv rec {
    name = "vmware-unpack-env";
    targetPkgs = pkgs: [ zlib ];
  };

  readline70_compat63 = symlinkJoin {
    name = "readline70_compat63";
    paths = [ readline70 ];
    postBuild = ''
      ln -s $out/lib/libreadline.so $out/lib/libreadline.so.6
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "vmware-workstation";
  inherit version build;

  buildInputs = [
    libxslt
    libxml2
    libuuid
    gdbm3
    readline
    xz
    cups
    glibc
    libaio
    vulkan-loader
    alsa-lib
    libpulseaudio
    libxcrypt-legacy
    libGL
    numactl
    libX11
    libXi
    kmod
  ];

  nativeBuildInputs = [ python3 vmware-unpack-env autoPatchelfHook makeWrapper ]
    ++ lib.optionals enableInstaller [ bzip2 sqlite readline70_compat63 ]
    ++ lib.optionals enableMacOSGuests [ unzip ];

  src = fetchzip {
    url = "${baseUrl}/core/VMware-Workstation-${version}-${build}.x86_64.bundle.tar";
    sha256 = "sha256-5PZZpXN/V687TXjqeTm8MEays4/QTf02jVfdpi9C7GI=";
    stripRoot = false;
  } + "/VMware-Workstation-${version}-${build}.x86_64.bundle";

  unpackPhase = let
    guestTools = lib.optionalString enableGuestTools (lib.concatMapStringsSep " " (src: "--install-component ${src}") guestToolsSrc);
  in
  ''
    ${vmware-unpack-env}/bin/vmware-unpack-env -c "sh ${src} ${guestTools} --extract unpacked"

    ${lib.optionalString enableMacOSGuests ''
      mkdir -p fusion/
      unzip "${darwinIsoSrc}" \
        "payload/VMware Fusion.app/Contents/Library/isoimages/x86_x64/darwin.iso" \
        "payload/VMware Fusion.app/Contents/Library/isoimages/x86_x64/darwinPre15.iso" \
        -d fusion/
    ''}
  '';

  patchPhase = lib.optionalString enableMacOSGuests ''
    cp -R "${unlockerSrc}" unlocker/

    substituteInPlace unlocker/unlocker.py --replace \
      "/usr/lib/vmware/bin/" "$out/lib/vmware/bin"

    substituteInPlace unlocker/unlocker.py --replace \
      "/usr/lib/vmware/lib/libvmwarebase.so/libvmwarebase.so" "$out/lib/vmware/lib/libvmwarebase.so/libvmwarebase.so"
  '';

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/etc/vmware \
      $out/etc/init.d \
      $out/lib/vmware \
      $out/share/doc

    #### Replicate vmware-installer's order but VMX first because of appLoader
    ${lib.optionalString enableInstaller ''
      ## VMware installer
      echo "Installing VMware Installer"
      unpacked="unpacked/vmware-installer"
      vmware_installer_version=$(cat "unpacked/vmware-installer/manifest.xml" | grep -oPm1 "(?<=<version>)[^<]+")
      dest="$out/lib/vmware-installer/$vmware_installer_version"

      mkdir -p $dest
      cp -r $unpacked/vmis* $dest/
      cp -r $unpacked/sopython $dest/
      cp -r $unpacked/python $dest/
      cp -r $unpacked/cdsHelper $dest/
      cp -r $unpacked/vmware* $dest/
      cp -r $unpacked/bin $dest/
      cp -r $unpacked/lib $dest/

      chmod +x $dest/vmis-launcher $dest/sopython/* $dest/python/init.sh $dest/vmware-*
      ln -s $dest/vmware-installer $out/bin/vmware-installer

      mkdir -p $out/etc/vmware-installer
      cp ${./vmware-installer-bootstrap} $out/etc/vmware-installer/bootstrap
      sed -i -e "s,@@INSTALLERDIR@@,$dest," $out/etc/vmware-installer/bootstrap
      sed -i -e "s,@@IVERSION@@,$vmware_installer_version," $out/etc/vmware-installer/bootstrap
      sed -i -e "s,@@BUILD@@,${build}," $out/etc/vmware-installer/bootstrap

      # create database of vmware guest tools (avoids vmware fetching them later)
      mkdir -p $out/etc/vmware-installer/components
      database_filename=$out/etc/vmware-installer/database
      touch $database_filename
      sqlite3 "$database_filename" "CREATE TABLE settings(key VARCHAR PRIMARY KEY, value VARCHAR NOT NULL, component_name VARCHAR NOT NULL);"
      sqlite3 "$database_filename" "INSERT INTO settings(key,value,component_name) VALUES('db.schemaVersion','2','vmware-installer');"
      sqlite3 "$database_filename" "CREATE TABLE components(id INTEGER PRIMARY KEY, name VARCHAR NOT NULL, version VARCHAR NOT NULL, buildNumber INTEGER NOT NULL, component_core_id INTEGER NOT NULL, longName VARCHAR NOT NULL, description VARCHAR, type INTEGER NOT NULL);"
      for folder in unpacked/**/.installer ; do
        component="$(basename $(dirname $folder))"
        component_version=$(cat unpacked/$component/manifest.xml | grep -oPm1 "(?<=<version>)[^<]+")
        component_core_id=$([ "$component" == "vmware-installer" ] && echo "-1" || echo "1")
        type=$([ "$component" == "vmware-workstation" ] && echo "0" || echo "1")
        sqlite3 "$database_filename" "INSERT INTO components(name,version,buildNumber,component_core_id,longName,description,type) VALUES('$component','$component_version',${build},$component_core_id,'$component','$component',$type);"
        mkdir -p $out/etc/vmware-installer/components/$component
        cp -r $folder/* $out/etc/vmware-installer/components/$component
      done
    ''}

    ## VMware Bootstrap
    echo "Installing VMware Bootstrap"
    cp ${./vmware-bootstrap} $out/etc/vmware/bootstrap
    sed -i -e "s,@@PREFIXDIR@@,$out," $out/etc/vmware/bootstrap

    ## VMware Config
    echo "Installing VMware Config"
    cp ${./vmware-config} $out/etc/vmware/config
    sed -i -e "s,@@VERSION@@,${version}," $out/etc/vmware/config
    sed -i -e "s,@@BUILD@@,${build}," $out/etc/vmware/config
    sed -i -e "s,@@PREFIXDIR@@,$out," $out/etc/vmware/config

    ## VMware VMX
    echo "Installing VMware VMX"
    unpacked="unpacked/vmware-vmx"
    cp -r $unpacked/bin/* $out/bin/
    cp -r $unpacked/etc/modprobe.d $out/etc/
    cp -r $unpacked/etc/init.d/* $out/etc/init.d/
    cp -r $unpacked/roms $out/lib/vmware/
    cp -r $unpacked/sbin/* $out/bin/

    cp -r $unpacked/lib/libconf $out/lib/vmware/
    rm $out/lib/vmware/libconf/etc/fonts/fonts.conf

    cp -r $unpacked/lib/bin $out/lib/vmware/
    cp -r $unpacked/lib/lib $out/lib/vmware/
    cp -r $unpacked/lib/scripts $out/lib/vmware/
    cp -r $unpacked/lib/icu $out/lib/vmware/
    cp -r $unpacked/lib/share $out/lib/vmware/
    cp -r $unpacked/lib/modules $out/lib/vmware/
    cp -r $unpacked/lib/include $out/lib/vmware/

    cp -r $unpacked/extra/checkvm $out/bin/
    cp -r $unpacked/extra/modules.xml $out/lib/vmware/modules/

    ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-vmblock-fuse
    ln -s $out/lib/vmware/icu $out/etc/vmware/icu

    # Replace vmware-modconfig with simple error dialog
    cp ${./vmware-modconfig} $out/bin/vmware-modconfig
    sed -i -e "s,ETCDIR=/etc/vmware,ETCDIR=$out/etc/vmware," $out/bin/vmware-modconfig

    # Patch dynamic libs in
    for binary in "mksSandbox" "mksSandbox-debug" "mksSandbox-stats" "vmware-vmx" "vmware-vmx-debug" "vmware-vmx-stats"
    do
      patchelf \
        --add-needed ${libaio}/lib/libaio.so.1 \
        --add-needed ${vulkan-loader}/lib/libvulkan.so.1 \
        --add-needed ${alsa-lib}/lib/libasound.so \
        --add-needed ${libpulseaudio}/lib/libpulse.so.0 \
        --add-needed ${libGL}/lib/libEGL.so.1 \
        --add-needed ${numactl}/lib/libnuma.so.1 \
        --add-needed ${libX11}/lib/libX11.so.6 \
        --add-needed ${libXi}/lib/libXi.so.6 \
        --add-needed ${libGL}/lib/libGL.so.1 \
        $out/lib/vmware/bin/$binary
    done

    ## VMware USB Arbitrator
    echo "Installing VMware USB Arbitrator"
    unpacked="unpacked/vmware-usbarbitrator"
    cp -r $unpacked/etc/init.d/* $out/etc/init.d/
    cp -r $unpacked/bin/* $out/bin/
    ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-usbarbitrator

    ## VMware Player Setup
    echo "Installing VMware Player Setup"
    unpacked="unpacked/vmware-player-setup"
    mkdir -p $out/lib/vmware/setup
    cp $unpacked/vmware-config $out/lib/vmware/setup/

    ## VMware Network Editor
    echo "Installing VMware Network Editor"
    unpacked="unpacked/vmware-network-editor"
    cp -r $unpacked/lib $out/lib/vmware/

    mkdir -p $out/lib/vmware/isoimages/

    ${lib.optionalString enableGuestTools ''
    echo "Installing VMware Tools"
    cp unpacked/vmware-tools-linux/linux.iso \
       unpacked/vmware-tools-linuxPreGlibc25/linuxPreGlibc25.iso \
       unpacked/vmware-tools-netware/netware.iso \
       unpacked/vmware-tools-solaris/solaris.iso \
       unpacked/vmware-tools-winPre2k/winPre2k.iso \
       unpacked/vmware-tools-winPreVista/winPreVista.iso \
       unpacked/vmware-tools-windows/windows.iso \
       $out/lib/vmware/isoimages/
    ''}

    ${lib.optionalString enableMacOSGuests ''
      echo "Installing VMWare Tools for MacOS"
      cp -v \
       "fusion/payload/VMware Fusion.app/Contents/Library/isoimages/x86_x64/darwin.iso" \
       "fusion/payload/VMware Fusion.app/Contents/Library/isoimages/x86_x64/darwinPre15.iso" \
       $out/lib/vmware/isoimages/
    ''}

    ## VMware Player Application
    echo "Installing VMware Player Application"
    unpacked="unpacked/vmware-player-app"
    cp -r $unpacked/lib/* $out/lib/vmware/
    cp -r $unpacked/share/* $out/share/
    cp -r $unpacked/bin/* $out/bin/
    cp -r $unpacked/doc/* $out/share/doc/ # Licences

    for target in "vmplayer" "vmware-enter-serial" "vmware-setup-helper" "licenseTool" "vmware-mount" "vmware-fuseUI" "vmware-app-control" "vmware-zenity"
    do
      ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/$target
    done

    ln -s $out/lib/vmware/bin/vmware-mount $out/bin/vmware-mount
    ln -s $out/lib/vmware/bin/vmware-fuseUI $out/bin/vmware-fuseUI
    ln -s $out/lib/vmware/bin/vmrest $out/bin/vmrest

    # Patch vmplayer
    sed -i -e "s,ETCDIR=/etc/vmware,ETCDIR=$out/etc/vmware," $out/bin/vmplayer
    sed -i -e "s,/sbin/modprobe,${kmod}/bin/modprobe," $out/bin/vmplayer
    sed -i -e "s,@@BINARY@@,$out/bin/vmplayer," $out/share/applications/vmware-player.desktop

    ## VMware OVF Tool compoment
    echo "Installing VMware OVF Tool for Linux"
    unpacked="unpacked/vmware-ovftool"
    mkdir -p $out/lib/vmware-ovftool/

    cp -r $unpacked/* $out/lib/vmware-ovftool/
    chmod 755 $out/lib/vmware-ovftool/ovftool*
    makeWrapper "$out/lib/vmware-ovftool/ovftool.bin" "$out/bin/ovftool"

    ## VMware Network Editor User Interface
    echo "Installing VMware Network Editor User Interface"
    unpacked="unpacked/vmware-network-editor-ui"
    cp -r $unpacked/share/* $out/share/

    ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-netcfg
    ln -s $out/lib/vmware/bin/vmware-netcfg $out/bin/vmware-netcfg

    # Patch network editor ui

    sed -i -e "s,@@BINARY@@,$out/bin/vmware-netcfg," $out/share/applications/vmware-netcfg.desktop

    ## VMware VIX Core Library
    echo "Installing VMware VIX Core Library"
    unpacked="unpacked/vmware-vix-core"
    mkdir -p $out/lib/vmware-vix
    cp -r $unpacked/lib/* $out/lib/vmware-vix/
    cp -r $unpacked/bin/* $out/bin/
    cp $unpacked/*.txt $out/lib/vmware-vix/

    mkdir -p $out/share/doc/vmware-vix/
    cp -r $unpacked/doc/* $out/share/doc/vmware-vix/

    mkdir -p $out/include/
    cp -r $unpacked/include/* $out/include/

    ## VMware VIX Workstation-17.0.0 Library
    echo "Installing VMware VIX Workstation-17.0.0 Library"
    unpacked="unpacked/vmware-vix-lib-Workstation1700"
    cp -r $unpacked/lib/* $out/lib/vmware-vix/

    ## VMware VProbes component for Linux
    echo "Installing VMware VProbes component for Linux"
    unpacked="unpacked/vmware-vprobe"
    cp -r $unpacked/bin/* $out/bin/
    cp -r $unpacked/lib/* $out/lib/vmware/

    ## VMware Workstation
    echo "Installing VMware Workstation"
    unpacked="unpacked/vmware-workstation"
    cp -r $unpacked/bin/* $out/bin/
    cp -r $unpacked/lib/* $out/lib/vmware/
    cp -r $unpacked/share/* $out/share/
    cp -r $unpacked/man $out/share/
    cp -r $unpacked/doc $out/share/

    ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware
    ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-tray
    ln -s $out/lib/vmware/bin/appLoader $out/lib/vmware/bin/vmware-vprobe

    # Patch vmware
    sed -i -e "s,ETCDIR=/etc/vmware,ETCDIR=$out/etc/vmware,g" $out/bin/vmware
    sed -i -e "s,/sbin/modprobe,${kmod}/bin/modprobe,g" $out/bin/vmware
    sed -i -e "s,@@BINARY@@,$out/bin/vmware," $out/share/applications/vmware-workstation.desktop

    chmod +x $out/bin/* $out/lib/vmware/bin/* $out/lib/vmware/setup/*

    # Harcoded pkexec hack
    for lib in "lib/vmware/lib/libvmware-mount.so/libvmware-mount.so" "lib/vmware/lib/libvmwareui.so/libvmwareui.so" "lib/vmware/lib/libvmware-fuseUI.so/libvmware-fuseUI.so"
    do
      sed -i -e "s,/usr/local/sbin,/run/vmware/bin," "$out/$lib"
    done

    ${lib.optionalString enableMacOSGuests ''
      echo "Running VMWare Unlocker to enable macOS Guests"
      python3 unlocker/unlocker.py
    ''}

    # SUID hack
    wrapProgram $out/lib/vmware/bin/vmware-vmx
    rm $out/lib/vmware/bin/vmware-vmx
    ln -s /run/wrappers/bin/vmware-vmx $out/lib/vmware/bin/vmware-vmx
  '';

  meta = with lib; {
    description = "Industry standard desktop hypervisor for x86-64 architecture";
    homepage = "https://www.vmware.com/products/workstation-pro.html";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cawilliamson deinferno vifino ];
  };
}
