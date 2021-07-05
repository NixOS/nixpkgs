{stdenv
, stdenvNoCC
, removeReferencesTo
, lib
, fetchurl
, fetchpatch
, cacert
, utillinux
, gpgme
, openssl
, libuuid
, coreutils
, go
, which
, makeWrapper
, cryptsetup
, squashfsTools
, buildGoPackage}:

with lib;

let
  version = "3.6.4";

  # Patch the singularity source by revendoring and backporting changes
  # to support umoci v0.4.7; addresses CVE-2021-29136
  patchedSrc = stdenvNoCC.mkDerivation {
    name = "singularity-${version}-src";

    src = fetchurl {
      url = "https://github.com/hpcng/singularity/releases/download/v${version}/singularity-${version}.tar.gz";
      sha256 = "17z7v7pjq1ibl64ir4h183sp58v2x7iv6dn6imnnhkdvss0kl8vi";
    };

    nativeBuildInputs = [ go cacert ];

    phases = [ "unpackPhase" "patchPhase" "buildPhase" "installPhase" ];

    patches = [((fetchpatch {
      url = "https://github.com/hpcng/singularity/commit/6e59f31cb97ff59e323850aa1339a38a11358429.patch";
      sha256 = "sha256-pypzgRr7LO589TBqhHEKZ+eP6/4w7OQQ1dBgsro47G0=";
      includes = [ "internal/pkg/build/sources/oci_unpack.go" ];
    }).overrideAttrs (attrs: {
      postFetch = attrs.postFetch + ''
        substituteInPlace $out --replace \
          "internal/pkg/build/sources/oci_unpack.go" \
          "internal/pkg/build/sources/oci_unpack_linux.go"
      '';
    }))];

    buildPhase = ''
      runHook preBuild
      substituteInPlace go.mod --replace \
        'github.com/opencontainers/umoci v0.4.6-0.20200622135030-30d116059d97' \
        'github.com/opencontainers/umoci v0.4.7'
      HOME=$TMPDIR GO111MODULE=on go mod vendor
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r ./* $out
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-IAtFklXI6x6jKV3uNYrFsQre4iepCz/hU8Z/X9QWBoY=";

  };

in buildGoPackage rec {
  pname = "singularity";
  inherit version;

  src = patchedSrc;

  goPackagePath = "github.com/sylabs/singularity";
  goDeps = ./deps.nix;

  buildInputs = [ gpgme openssl libuuid ];
  nativeBuildInputs = [ removeReferencesTo utillinux which makeWrapper cryptsetup ];
  propagatedBuildInputs = [ coreutils squashfsTools ];

  postPatch = ''
    substituteInPlace internal/pkg/build/files/copy.go \
      --replace /bin/cp ${coreutils}/bin/cp
  '';

  postConfigure = ''
    cd go/src/github.com/sylabs/singularity

    patchShebangs .
    sed -i 's|defaultPath := "[^"]*"|defaultPath := "${stdenv.lib.makeBinPath propagatedBuildInputs}"|' cmd/internal/cli/actions.go

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
    sed -i 's|^# mksquashfs path =.*$|mksquashfs path = ${stdenv.lib.makeBinPath [squashfsTools]}/mksquashfs|' $out/etc/singularity/singularity.conf
    sed -i 's|^# cryptsetup path =.*$|cryptsetup path = ${stdenv.lib.makeBinPath [cryptsetup]}/cryptsetup|' $out/etc/singularity/singularity.conf

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.sylabs.io/";
    description = "Application containers for linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
