{stdenv
, removeReferencesTo
, lib
, fetchgit
, fetchFromGitHub
, utillinux
, openssl
, coreutils
, gawk
, go
, which
, makeWrapper
, squashfsTools
, buildGoPackage}:

with lib;

buildGoPackage rec {
  name = "singularity-${version}";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "sylabs";
    repo = "singularity";
    rev = "v${version}";
    sha256 = "1wpsd0il2ipa2n5cnbj8dzs095jycdryq2rx62kikbq7ahzz4fsi";
  };

  goPackagePath = "github.com/sylabs/singularity";
  goDeps = ./deps.nix;

  buildInputs = [ openssl ];
  nativeBuildInputs = [ removeReferencesTo utillinux which makeWrapper ];
  propagatedBuildInputs = [ coreutils squashfsTools ];

  postConfigure = ''
    find . -name vendor -type d -print0 | xargs -0 rm -rf

    cd go/src/github.com/sylabs/singularity

    patchShebangs .
    sed -i 's|defaultEnv := "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"|defaultEnv := "${stdenv.lib.makeBinPath propagatedBuildInputs}"|' src/cmd/singularity/cli/singularity.go

    ./mconfig -V ${version} -p $bin --localstatedir=/var
    touch builddir/.dep-done
    touch builddir/vendors-done

    # Don't install SUID binaries
    sed -i 's/-m 4755/-m 755/g' builddir/Makefile

    # Point to base gopath
    sed -i "s|^cni_vendor_GOPATH :=.*\$|cni_vendor_GOPATH := $NIX_BUILD_TOP/go/src/github.com/containernetworking/plugins/plugins|" builddir/Makefile
  '';

  buildPhase = ''
    make -C builddir
  '';

  installPhase = ''
    make -C builddir install LOCALSTATEDIR=$bin/var
    chmod 755 $bin/libexec/singularity/bin/starter-suid
  '';

  postFixup = ''
    find $bin/ -type f -executable -exec remove-references-to -t ${go} '{}' + || true

    # These etc scripts shouldn't have their paths patched
    cp etc/actions/* $bin/etc/singularity/actions/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.sylabs.io/;
    description = "Application containers for linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
