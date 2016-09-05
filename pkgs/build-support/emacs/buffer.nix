# Functions to build elisp files to locally configure emcas buffers.
# See https://github.com/shlevy/nix-buffer

{ runCommand }:

{
  withPackages = pkgs: runCommand "dir-locals.el" { inherit pkgs; } ''
    echo        "(make-local-variable 'process-environment)" >> $out
    echo        "(setenv \"PATH\" (concat" >> $out
    for pkg in $pkgs; do
      echo        "                \"$pkg/bin:$pkg/sbin\"" >> $out
    done
    echo          "                (getenv \"PATH\")))" >> $out
    echo -n       "(setq-local exec-path (append '(" >> $out
    for pkg in $pkgs; do
      echo -en  "\n                                \"$pkg/bin\" \"$pkg/sbin\"" >> $out
    done
    echo -e   ")\\n                              exec-path))" >> $out
  '';
}
