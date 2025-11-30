# This function compiles a source tarball in a virtual machine image
# that contains a Debian-like (i.e. dpkg-based) OS.

{
  name ? "debian-build",
  diskImage,
  src,
  lib,
  stdenv,
  vmTools,
  checkinstall,
  fsTranslation ? false,
  # Features provided by this package.
  debProvides ? [ ],
  # Features required by this package.
  debRequires ? [ ],
  ...
}@args:

vmTools.runInLinuxImage (
  stdenv.mkDerivation (

    {
      doCheck = true;

      prefix = "/usr";

      prePhases = [
        "installExtraDebsPhase"
        "sysInfoPhase"
      ];
    }

    // removeAttrs args [
      "vmTools"
      "lib"
    ]
    //

      {
        name = name + "-" + diskImage.name + (lib.optionalString (src ? version) "-${src.version}");

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
          echo "installed Debian packages"
          dpkg-query --list
        '';

        installPhase = ''
          eval "$preInstall"
          export LOGNAME=root

          # otherwise build hangs when it wants to display
          # the log file
          export PAGER=cat
          ${checkinstall}/sbin/checkinstall --nodoc -y -D \
            --fstrans=${lib.boolToYesNo fsTranslation} \
            --requires="${lib.concatStringsSep "," debRequires}" \
            --provides="${lib.concatStringsSep "," debProvides}" \
            ${
              if (src ? version) then "--pkgversion=$(echo ${src.version} | tr _ -)" else "--pkgversion=0.0.0"
            } \
            ''${debMaintainer:+--maintainer="'$debMaintainer'"} \
            ''${debName:+--pkgname="'$debName'"} \
            $checkInstallFlags \
            -- \
            $SHELL -c "''${installCommand:-make install}"

          mkdir -p $out/debs
          find . -name "*.deb" -exec cp {} $out/debs \;

          [ "$(echo $out/debs/*.deb)" != "" ]

          for i in $out/debs/*.deb; do
            echo "Generated DEB package: $i"
            dpkg-deb --info "$i"
            pkgName=$(dpkg-deb -W "$i" | awk '{print $1}')
            echo "file deb $i" >> $out/nix-support/hydra-build-products
          done
          dpkg -i $out/debs/*.deb

          for i in $extraDebs; do
            echo "file deb-extra $(ls $i/debs/*.deb | sort | head -1)" >> $out/nix-support/hydra-build-products
          done

          eval "$postInstall"
        '';

        meta = (lib.optionalAttrs (args ? meta) args.meta) // {
          description = "Deb package for ${diskImage.fullName}";
        };
      }

  )
)
