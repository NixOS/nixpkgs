x@{builderDefsPackage
  , gnome, gtk, glib, libxml2, libvirt, gtkvnc, cyrus_sasl, libtasn1, wget,curl
  , intltool, python
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["gnome"];

  buildInputs = (map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames)))
    ++ [gnome.libglade intltool python libvirt];
  sourceInfo = rec {
    baseName="virt-manager";

    version = "0.9.1"; 
    name = "virt-manager-${version}";
    url = "http://virt-manager.et.redhat.com/download/sources/virt-manager/virt-manager-${version}.tar.gz";
    hash = "15e064167ba5ff84ce6fc8790081d61890430f2967f89886a84095a23e40094a";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  patchPhase = a.fullDepEntry '' 
    substituteInPlace "src/virt-manager.in" --replace "exec /usr/bin/python" "exec ${python}/bin/python"
  '' ["minInit"];

  inherit (sourceInfo) name version;
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = [ "doUnpack" "patchPhase" "doConfigure" "doMakeInstall"];

  #configureFlags = [
  #  --with-libvirt-package-names=libvirt \
  #  --with-kvm-packages=qemu-system-x86

  #  --with-libvirt-package-names=libvirt \
  #  --with-kvm-packages=qemu-kvm

  #  --with-libvirt-package-names=%libvirt_packages \
  #  --with-kvm-packages=%kvm_packages \
  #  "--with-libvirt-package-names=libvirt.py"
  #];

  meta = {
    homepage = http://virt-manager.org;
    description = "The 'Virtual Machine Manager' application (virt-manager for short package name) is a desktop user interface for managing virtual machines.";
  
    maintainers = with a.lib.maintainers;
    [
      qknight
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://virt-manager.org/download.html";
    };
  };
}) x

