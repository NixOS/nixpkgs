# This function builds an RPM from a source tarball that contains a
# RPM spec file (i.e., one that can be built using `rpmbuild -ta').

{ name ? "rpm-build"
, diskImage
, src, vmTools
, ... } @ args:

vmTools.buildRPM (

  removeAttrs args ["vmTools"] //

  {
    name = name + "-" + diskImage.name + (if src ? version then "-" + src.version else "");

    preBuild = ''
      . ${./functions.sh}
      propagateImageName
      src=$(findTarballs $src | head -1) # Pick the first tarball.
    '';

    postInstall = ''
      declare -a rpms rpmNames
      for i in $out/rpms/*/*.rpm; do
        if echo $i | grep -vq "\.src\.rpm$"; then
          echo "file rpm $i" >> $out/nix-support/hydra-build-products
          rpms+=($i)
          rpmNames+=("$(rpm -qp "$i")")
        fi
      done

      echo "installing ''${rpms[*]}..."
      rpm -Up ''${rpms[*]} --excludepath /nix/store

      eval "$postRPMInstall"

      echo "uninstalling ''${rpmNames[*]}..."
      rpm -e ''${rpmNames[*]} --nodeps

      for i in $out/rpms/*/*.src.rpm; do
        echo "file srpm $i" >> $out/nix-support/hydra-build-products
      done

      for rpmdir in $extraRPMs ; do
        echo "file rpm-extra $(ls $rpmdir/rpms/*/*.rpm | grep -v 'src\.rpm' | sort | head -1)" >> $out/nix-support/hydra-build-products
      done
    ''; # */

    meta = (if args ? meta then args.meta else {}) // {
      description = "RPM package for ${diskImage.fullName}";
    };
  }

)
