{stdenv, fetchurl, fetchgit, nix-template-rpm }:

# Xenserver buildroot of somehow around XenServer 6.5.
# Xenserver is not an application by itself, but just a collection of components.
# This package only provides the build inputs to actually build the components of xenserver.
stdenv.mkDerivation rec {
  name = "xenserver-${version}";
  version = "2015012901";

  src = fetchgit {
    url = "https://github.com/xenserver/buildroot";
    rev = "5e9892582c3733416bf8b6ebf9aece8cefa15b28";
    sha256 = "6ee4288fb715e1315ff0cc7923ec1efe896be176d6697a7d56015b77b4317447";
  };

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ nix-template-rpm ];

    #cp ${ ./buildRootInput.nix } $out/usr/share/buildroot/buildRootInput.nix
  installPhase = ''
    mkdir -p $out/usr/share/buildroot
    cp -r SPECS $out/usr/share/buildroot/
    cp -r SOURCES $out/usr/share/buildroot/
    cp ${ ./translation.table } $out/usr/share/buildroot/translation.table

    #
    # generate script to update buildRootInput.nix
    #
    mkdir -p $out/bin
    cat << EOF > $out/bin/xapi-generate-nix-buildRootInput
    #!$SHELL
    if [ -e nixpkgs ] || [ -e buildRootInput.nix ] || [ -e translation.table ]
    then
      echo "Error: directory 'nixpkgs', file 'buildRootInput.nix' or file 'translation.table' does already exist!"
      exit 1
    fi

    tmpDir=\$(mktemp -d)
    mkdir -p nixpkgs/top-level
    cd nixpkgs
    ${nix-template-rpm}/bin/nix-template-rpm -m XENSERVER_MAINTAINER -i $out/usr/share/buildroot/SOURCES/ -o applications/virtualization/xapi -a top-level/all-packages.nix -t $out/usr/share/buildroot/translation.table -u ../translation.table "\$@" $out/usr/share/buildroot/SPECS/*.spec
    cd ..
    EOF

    chmod +x $out/bin/xapi-generate-nix-buildRootInput
    '';

  meta = {
    homepage = http://www.xenserver.org;
    description = "XenServer/XAPI build input";
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
