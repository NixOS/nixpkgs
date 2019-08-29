{ lib, buildGoPackage, fetchFromGitHub, go-bindata, pkgconfig, makeWrapper
, glib, gtk3, libappindicator-gtk3, gpgme, openshift, ostree, libselinux, btrfs-progs
, lvm2, docker-machine-kvm
}:

let
  version = "1.34.0";

  # Update these on version bumps according to Makefile
  centOsIsoVersion = "v1.15.0";
  openshiftVersion = "v3.11.0";

in buildGoPackage rec {
  name = "minishift-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "minishift";
    repo = "minishift";
    rev = "v${version}";
    sha256 = "0nc1g4lmz5ww6rjyyanp9vq4sj6fvi9zf9qjc4lpsmapddhjkdy7";
  };

  nativeBuildInputs = [ pkgconfig go-bindata makeWrapper ];
  buildInputs = [ glib gtk3 libappindicator-gtk3 gpgme ostree libselinux btrfs-progs lvm2 ];

  goPackagePath = "github.com/minishift/minishift";
  subPackages = [ "cmd/minishift" ];

  postPatch = ''
    # minishift downloads openshift if not found therefore set the cache to /nix/store/...
    substituteInPlace pkg/minishift/cache/oc_caching.go \
      --replace 'filepath.Join(oc.MinishiftCacheDir, OC_CACHE_DIR, oc.OpenShiftVersion, runtime.GOOS)' '"${openshift}/bin"' \
      --replace '"runtime"' ""
  '';

  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/pkg/version.minishiftVersion=${version}
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
      --prefix PATH ':' '${lib.makeBinPath [ docker-machine-kvm openshift ]}'
  '';

  meta = with lib; {
    description = "Run OpenShift locally";
    longDescription = ''
      Minishift is a tool that helps you run OpenShift locally by running
      a single-node OpenShift cluster inside a VM. You can try out OpenShift
      or develop with it, day-to-day, on your local host.
    '';
    homepage = https://github.com/minishift/minishift;
    maintainers = with maintainers; [ fpletz vdemeester ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
