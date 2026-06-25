/*
  Build a channel tarball. These contain, in addition to the nixpkgs
  expressions themselves, files that indicate the version of nixpkgs
  that they represent.
*/
{
  pkgs,
  nixpkgs,
  version,
  versionSuffix,
}:

pkgs.releaseTools.makeSourceTarball {
  name = "nixos-channel";

  src = nixpkgs;

  officialRelease = false; # FIXME: fix this in makeSourceTarball
  inherit version versionSuffix;

  buildInputs = with pkgs; [
    nix
    zstd
  ];

  distPhase = ''
    rm -rf .git
    echo -n $VERSION_SUFFIX > .version-suffix
    echo -n ${nixpkgs.rev or nixpkgs.shortRev} > .git-revision
    releaseName=nixos-$VERSION$VERSION_SUFFIX
    mkdir -p $out/tarballs
    cp -prd . ../$releaseName
    chmod -R u+w ../$releaseName
    ln -s . ../$releaseName/nixpkgs # hack to make ‘<nixpkgs>’ work
    NIX_STATE_DIR=$TMPDIR nix-env -f ../$releaseName/default.nix -qaP --meta --show-trace --xml \* > /dev/null
    cd ..
    chmod -R u+w $releaseName
    XZ_OPT="-T0" tar \
      --create \
      --file=$out/tarballs/$releaseName.tar.xz \
      --xz \
      --absolute-names \
      --owner=0 \
      --group=0 \
      --numeric-owner \
      --format=gnu \
      --sort=name \
      --mtime="@$SOURCE_DATE_EPOCH" \
      --hard-dereference \
      $releaseName

    tar \
      --create \
      --file="$out/tarballs/$releaseName.tar.zst" \
      --use-compress-program="zstd -19 -T0" \
      --absolute-names \
      --owner=0 \
      --group=0 \
      --numeric-owner \
      --format=gnu \
      --sort=name \
      --mtime="@$SOURCE_DATE_EPOCH" \
      --hard-dereference \
      $releaseName
  '';
}
