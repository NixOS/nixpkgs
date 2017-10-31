{stdenv, fetchgit, fetchsvn, bash } :

let
  mkscript = path : text : ''
    mkdir -pv `dirname ${path}`
    cat > ${path} <<"EOF"
    #!${bash}/bin/bash
    ME=`basename ${path}`
    ${text}
    EOF
    sed -i "s@%out@$out@g" ${path}
    chmod +x ${path}
  '';
  
  hashname = r: let
    rpl = stdenv.lib.replaceChars [":" "/"] ["_" "_"];
  in
    (rpl r.url) + "-" + (rpl r.rev);

in

stdenv.mkDerivation {
  name = "fakegit";

  buildCommand = ''
    mkdir -pv $out/repos
    ${stdenv.lib.concatMapStrings
       (r : ''
        cp -r ${fetchgit r} $out/repos/${hashname r}
       ''
       ) (import ./src-libs-git.nix)
    }

    ${mkscript "$out/bin/checkout-git.sh" ''
      if test "$#" -ne 4; then
        echo "Usage: $0 DESTINATION URL GITBRANCH HASH"
        exit 1
      fi
      DEST=$1
      URL=`echo $2 | tr :/ __`
      GITBRANCH=$3
      REVISION=$4

      L=`echo $REVISION | wc -c`
      if expr $L '<' 10 >/dev/null; then
        REVISION=refs/tags/$REVISION
      fi

      REVISION=`echo $REVISION | tr :/ __`

      rm -rf $DEST
      mkdir -pv $DEST
      echo "FAKEGIT cp -r %out/repos/$URL-$REVISION $DEST" >&2
      cp -r %out/repos/$URL-$REVISION/* $DEST
      chmod u+w -R $DEST
    ''}

    ${stdenv.lib.concatMapStrings
       (r : ''
        cp -r ${fetchsvn r} $out/repos/${hashname r}
       ''
       ) (import ./src-libs-svn.nix)
    }

    ${mkscript "$out/bin/checkout-svn.sh" ''
      if test "$#" -ne 3; then
        echo "Usage: $0 DESTINATION URL REVISION"
        exit 1
      fi
      DEST=$1
      URL=`echo $2 | tr :/ __`
      REVISION=`echo $4 | tr :/ __`

      rm -rf $DEST
      mkdir -pv $DEST
      echo "FAKE COPY %out/repos/$URL-$REVISION $DEST"
      cp -r %out/repos/$URL-$REVISION/* $DEST
      chmod u+w -R $DEST
    ''}
  '';
}
