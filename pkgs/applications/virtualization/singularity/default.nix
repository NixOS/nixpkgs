{stdenv
, removeReferencesTo
, lib
, fetchFromGitHub
, utillinux
, openssl
, coreutils
, go
, which
, makeWrapper
, squashfsTools
, buildGoPackage}:

with lib;

buildGoPackage rec {
  pname = "singularity";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "sylabs";
    repo = "singularity";
    rev = "v${version}";
    sha256 = "14lhxwy21s7q081x7kbnvkjsbxgsg2f181qlzmlxcn6n7gfav3kj";
  };

  goPackagePath = "github.com/sylabs/singularity";
  goDeps = ./deps.nix;

  buildInputs = [ openssl utillinux ];
  nativeBuildInputs = [ removeReferencesTo which makeWrapper ];
  propagatedBuildInputs = [ coreutils squashfsTools ];

  prePatch = ''
    substituteInPlace internal/pkg/build/copy/copy.go \
      --replace /bin/cp ${coreutils}/bin/cp
  '';

  postConfigure = ''
    cd go/src/github.com/sylabs/singularity

    patchShebangs .
    sed -i 's|defaultPath := "[^"]*"|defaultPath := "${stdenv.lib.makeBinPath propagatedBuildInputs}"|' cmd/internal/cli/actions.go

    ./mconfig -V ${version} -p $bin --localstatedir=/var

    # Don't install SUID binaries
    sed -i 's/-m 4755/-m 755/g' builddir/Makefile

  '';

  buildPhase = ''
    make -C builddir
  '';

  installPhase = ''
    make -C builddir install LOCALSTATEDIR=$bin/var
    chmod 755 $bin/libexec/singularity/bin/starter-suid
    wrapProgram $bin/bin/singularity --prefix PATH : ${stdenv.lib.makeBinPath propagatedBuildInputs}
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
