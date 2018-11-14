{ lib, buildGoPackage, fetchFromGitHub, go-bindata, pkgconfig, makeWrapper
, glib, gtk3, libappindicator-gtk3, gpgme, ostree, libselinux, btrfs-progs
, lvm2, docker-machine-kvm
}:

let
  version = "1.25.0";

  # Update these on version bumps according to Makefile
  b2dIsoVersion = "v1.3.0";
  centOsIsoVersion = "v1.12.0";
  openshiftVersion = "v3.11.0";

in buildGoPackage rec {
  name = "minishift-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "minishift";
    repo = "minishift";
    rev = "v${version}";
    sha256 = "12a1irj92lplzkr88g049blpjsdsfwfihs2xix971cq7v0w38fkf";
  };

  nativeBuildInputs = [ pkgconfig go-bindata makeWrapper ];
  buildInputs = [ glib gtk3 libappindicator-gtk3 gpgme ostree libselinux btrfs-progs lvm2 ];

  goPackagePath = "github.com/minishift/minishift";
  subPackages = [ "cmd/minishift" ];

  postPatch = ''
    substituteInPlace vendor/github.com/containers/image/storage/storage_image.go \
      --replace 'nil, diff' 'diff'
  '';

  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/pkg/version.minishiftVersion=${version}
      -X ${goPackagePath}/pkg/version.b2dIsoVersion=${b2dIsoVersion}
      -X ${goPackagePath}/pkg/version.centOsIsoVersion=${centOsIsoVersion}
      -X ${goPackagePath}/pkg/version.openshiftVersion=${openshiftVersion}
  '';

  preBuild = ''
    (cd go/src/github.com/minishift/minishift
      mkdir -p out/bindata
      go-bindata -prefix addons -o out/bindata/addon_assets.go -pkg bindata addons/...)
  '';

  postInstall = ''
    wrapProgram "$bin/bin/minishift" \
      --prefix PATH ':' '${lib.makeBinPath [ docker-machine-kvm ]}'
  '';

  meta = with lib; {
    description = "Run OpenShift locally";
    longDescription = ''
      Minishift is a tool that helps you run OpenShift locally by running
      a single-node OpenShift cluster inside a VM. You can try out OpenShift
      or develop with it, day-to-day, on your local host.
    '';
    homepage = https://github.com/minishift/minishift;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
