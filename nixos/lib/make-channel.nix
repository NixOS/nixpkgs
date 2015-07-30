{ pkgs, nixpkgs, version, versionSuffix }:

pkgs.releaseTools.makeSourceTarball {
  name = "nixos-channel";

  src = nixpkgs;

  officialRelease = false; # FIXME: fix this in makeSourceTarball
  inherit version versionSuffix;

  buildInputs = [ pkgs.nix ];

  expr = builtins.readFile ./channel-expr.nix;

  distPhase = ''
    rm -rf .git
    echo -n $VERSION_SUFFIX > .version-suffix
    echo -n ${nixpkgs.rev or nixpkgs.shortRev} > .git-revision
    releaseName=nixos-$VERSION$VERSION_SUFFIX
    mkdir -p $out/tarballs
    mkdir ../$releaseName
    cp -prd . ../$releaseName/nixpkgs
    chmod -R u+w ../$releaseName
    ln -s nixpkgs/nixos ../$releaseName/nixos
    echo "$expr" > ../$releaseName/default.nix
    NIX_STATE_DIR=$TMPDIR nix-env -f ../$releaseName/default.nix -qaP --meta --xml \* > /dev/null
    cd ..
    chmod -R u+w $releaseName
    tar cfJ $out/tarballs/$releaseName.tar.xz $releaseName
  '';
}
