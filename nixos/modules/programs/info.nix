{config, pkgs, ...}:

let

  texinfo = pkgs.texinfoInteractive;

  # Quick hack to make the `info' command work properly.  `info' needs
  # a "dir" file containing all the installed Info files, which we
  # don't have (it would be impure to have a package installation
  # update some global "dir" file).  So this wrapper script around
  # "info" builds a temporary "dir" file on the fly.  This is a bit
  # slow (on a cold cache) but not unacceptably so.
  infoWrapper = pkgs.writeScriptBin "info"
    ''
      #! ${pkgs.stdenv.shell}

      dir=$(mktemp --tmpdir -d "info.dir.XXXXXX")

      if test -z "$dir"; then exit 1; fi

      trap 'rm -rf "$dir"' EXIT

      shopt -s nullglob

      for i in $(IFS=:; echo $INFOPATH); do
          for j in $i/*.info; do
              ${texinfo}/bin/install-info --quiet $j $dir/dir
          done
      done

      INFOPATH=$dir:$INFOPATH ${texinfo}/bin/info "$@"
    ''; # */

in

{
  environment.systemPackages = [ infoWrapper texinfo ];
}
