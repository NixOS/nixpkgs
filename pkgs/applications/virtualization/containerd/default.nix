{ stdenv, lib, fetchFromGitHub, removeReferencesTo
, go, libapparmor, apparmor-parser, libseccomp, btrfs-progs }:

with lib;

stdenv.mkDerivation rec {
  name = "containerd-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "v${version}";
    sha256 = "1x6mmk69jksh4m9rjd8qwpp0qc7jmimpkq9pw9237p0v63p9yci0";
  };

  hardeningDisable = [ "fortify" ];

  buildInputs = [ removeReferencesTo go btrfs-progs ];
  buildFlags = "VERSION=v${version}";

  BUILDTAGS = []
    ++ optional (btrfs-progs == null) "no_btrfs";

  preConfigure = ''
    # Extract the source
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/github.com/containerd"
    mv "$sourceRoot" "go/src/github.com/containerd/containerd"
    export GOPATH=$NIX_BUILD_TOP/go:$GOPATH
'';

  preBuild = ''
    cd go/src/github.com/containerd/containerd
    patchShebangs .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  preFixup = ''
    find $out -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    homepage = https://containerd.tools/;
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
