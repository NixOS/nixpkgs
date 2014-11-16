# This function compiles a source tarball in a virtual machine image
# that contains a Debian-like (i.e. dpkg-based) OS.

{ name ? "debian-build"
, diskImage
, src, stdenv, vmTools, checkinstall
, fsTranslation ? false
, # Features provided by this package.
  debProvides ? []
, # Features required by this package.
  debRequires ? []
, ... } @ args:

with stdenv.lib;

vmTools.runInLinuxImage (stdenv.mkDerivation (

  {
    doCheck = true;

    prefix = "/usr";

    prePhases = "installExtraDebsPhase sysInfoPhase";
  }

  // removeAttrs args ["vmTools"] //

  {
    name = name + "-" + diskImage.name + (if src ? version then "-" + src.version else "");

    # !!! cut&paste from rpm-build.nix
    postHook = ''
      . ${./functions.sh}
      propagateImageName
      src=$(findTarball $src)
    '';

    installExtraDebsPhase = ''
      for i in $extraDebs; do
        dpkg --install $(ls $i/debs/*.deb | sort | head -1)
      done
    '';

    sysInfoPhase = ''
      [ ! -f /etc/lsb-release ] || (source /etc/lsb-release; echo "OS release: $DISTRIB_DESCRIPTION")
      echo "System/kernel: $(uname -a)"
      if test -e /etc/debian_version; then echo "Debian release: $(cat /etc/debian_version)"; fi
      header "installed Debian packages"
      dpkg-query --list
      stopNest
    '';

    installPhase = ''
      eval "$preInstall"
      export LOGNAME=root

      ${checkinstall}/sbin/checkinstall --nodoc -y -D \
        --fstrans=${if fsTranslation then "yes" else "no"} \
        --requires="${concatStringsSep "," debRequires}" \
        --provides="${concatStringsSep "," debProvides}" \
        ${optionalString (src ? version) "--pkgversion=$(echo ${src.version} | tr _ -)"} \
        ''${debMaintainer:+--maintainer="'$debMaintainer'"} \
        ''${debName:+--pkgname="'$debName'"} \
        $checkInstallFlags \
        -- \
        $SHELL -c "''${installCommand:-make install}"

      mkdir -p $out/debs
      find . -name "*.deb" -exec cp {} $out/debs \;

      [ "$(echo $out/debs/*.deb)" != "" ]

      for i in $out/debs/*.deb; do
        header "Generated DEB package: $i"
        dpkg-deb --info "$i"
        pkgName=$(dpkg-deb -W "$i" | awk '{print $1}')
        dpkg -i "$i"
        echo "file deb $i" >> $out/nix-support/hydra-build-products
        stopNest
      done

      for i in $extraDebs; do
        echo "file deb-extra $(ls $i/debs/*.deb | sort | head -1)" >> $out/nix-support/hydra-build-products
      done

      eval "$postInstall"
    ''; # */

    meta = (if args ? meta then args.meta else {}) // {
      description = "Deb package for ${diskImage.fullName}";
    };
  }

))
