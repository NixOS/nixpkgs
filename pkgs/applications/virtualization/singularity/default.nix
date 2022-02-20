{ lib
, fetchurl
, util-linux
, gpgme
, openssl
, libuuid
, coreutils
, which
, makeWrapper
, cryptsetup
, squashfsTools
, buildGoPackage}:

with lib;

buildGoPackage rec {
  pname = "singularity";
  version = "3.8.6";

  src = fetchurl {
    url = "https://github.com/hpcng/singularity/releases/download/v${version}/singularity-${version}.tar.gz";
    sha256 = "sha256-u1o7dnCsnHpLPOWyyfPWtb5g4hsI0zjJ39q7eyqZ9Sg=";
  };

  goPackagePath = "github.com/sylabs/singularity";

  buildInputs = [ gpgme openssl libuuid ];
  nativeBuildInputs = [ util-linux which makeWrapper cryptsetup ];
  propagatedBuildInputs = [ coreutils squashfsTools ];

  postPatch = ''
    substituteInPlace internal/pkg/build/files/copy.go \
      --replace /bin/cp ${coreutils}/bin/cp
  '';

  postConfigure = ''
    cd go/src/github.com/sylabs/singularity

    patchShebangs .
    sed -i 's|defaultPath := "[^"]*"|defaultPath := "${lib.makeBinPath propagatedBuildInputs}"|' cmd/internal/cli/actions.go

    ./mconfig -V ${version} -p $out --localstatedir=/var

    # Don't install SUID binaries
    sed -i 's/-m 4755/-m 755/g' builddir/Makefile
  '';

  buildPhase = ''
    runHook preBuild
    make -C builddir
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make -C builddir install LOCALSTATEDIR=$out/var
    chmod 755 $out/libexec/singularity/bin/starter-suid

    # Explicitly configure paths in the config file
    sed -i 's|^# mksquashfs path =.*$|mksquashfs path = ${lib.makeBinPath [squashfsTools]}/mksquashfs|' $out/etc/singularity/singularity.conf
    sed -i 's|^# cryptsetup path =.*$|cryptsetup path = ${lib.makeBinPath [cryptsetup]}/cryptsetup|' $out/etc/singularity/singularity.conf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.sylabs.io/";
    description = "Application containers for linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
