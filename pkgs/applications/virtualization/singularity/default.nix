{stdenv
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
, squashfsTools}:

with lib;

let

  goDeps = import ./deps.nix;

  installGoDep = {goPackagePath, fetch}:
  let gosrc = fetchgit { inherit (fetch) url rev sha256; };
  in ''
    mkdir -p src/$(dirname ${goPackagePath})
    cp -r ${gosrc} src/${goPackagePath}
  '';

in stdenv.mkDerivation rec {
  name = "singularity-${version}";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "sylabs";
    repo = "singularity";
    rev = "v${version}";
    sha256 = "1wpsd0il2ipa2n5cnbj8dzs095jycdryq2rx62kikbq7ahzz4fsi";
  };


  buildInputs = [ go utillinux openssl which makeWrapper ];
  propagatedBuildInputs = [ coreutils squashfsTools ];

  configurePhase = ''
    cd $TMPDIR
    mkdir -p src/github.com/sylabs/
    mv source src/github.com/sylabs/singularity
    ${concatMapStringsSep "\n" installGoDep goDeps}
    export GOPATH=$PWD
    chmod a+rw -R src
    find . -name vendor -type d -print0 | xargs -0 rm -rf

    cd src/github.com/sylabs/singularity

    patchShebangs .
    sed -i 's|defaultEnv := "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"|defaultEnv := "${stdenv.lib.makeBinPath propagatedBuildInputs}"|' src/cmd/singularity/cli/singularity.go

    ./mconfig -V ${version} -p $out --localstatedir=/var
    touch builddir/.dep-done
    touch builddir/vendors-done

    # Don't install SUID binaries
    sed -i 's/-m 4755/-m 755/g' builddir/Makefile

    # Point to base gopath
    sed -i "s|^cni_vendor_GOPATH :=.*\$|cni_vendor_GOPATH := $GOPATH/src/github.com/containernetworking/plugins/plugins|" builddir/Makefile
  '';

  buildPhase = ''
    make -C builddir
  '';

  installPhase = ''
    make -C builddir install LOCALSTATEDIR=$out/var
    chmod 755 $out/libexec/singularity/bin/starter-suid
  '';

  postFixup = ''
    # These etc scripts shouldn't have their paths patched
    cp etc/actions/* $out/etc/singularity/actions/
  '';


  meta = with stdenv.lib; {
    homepage = http://singularity.lbl.gov/;
    description = "Designed around the notion of extreme mobility of compute and reproducible science, Singularity enables users to have full control of their operating system environment";
    license = "BSD license with 2 modifications";
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
