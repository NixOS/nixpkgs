{ lib, stdenv, fetchgit, bash }:
let
  mkscript = path: text: ''
    mkdir -pv `dirname ${path}`
    cat > ${path} <<"EOF"
    #!${bash}/bin/bash
    ME=$(basename ${path})
    ${text}
    EOF
    sed -i "s@%out@$out@g" ${path}
    chmod +x ${path}
  '';

  hashname = r:
    let
      rpl = lib.replaceStrings [ ":" "/" ] [ "_" "_" ];
    in
    (rpl r.url) + "-" + (rpl r.rev);

in
stdenv.mkDerivation {
  name = "fakegit";

  buildCommand = ''
    mkdir -pv $out/repos
    ${lib.concatMapStrings
      (r: "cp -r ${fetchgit r} $out/repos/${hashname r}\n")
      (import ./src-libs.nix)}

    ${mkscript "$out/bin/checkout-git.sh" ''
      if test "$#" -ne 4; then
        echo "Usage: $0 DESTINATION URL GITBRANCH HASH"
        exit 1
      fi
      DEST=$1
      URL=`echo $2 | tr :/ __`
      GITBRANCH=$3
      REVISION=$4

      REVISION=`echo $REVISION | tr :/ __`

      rm -rf $DEST
      mkdir -pv $DEST
      echo "FAKEGIT cp -r %out/repos/$URL-$REVISION $DEST" >&2
      cp -r %out/repos/$URL-$REVISION/* $DEST
      chmod u+w -R $DEST
    ''}
  '';
}
