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

  buildInputs = [ pkgs.nix ];

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
    tar cfJ $out/tarballs/$releaseName.tar.xz $releaseName
  '';
}
