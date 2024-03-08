{ elpaBuild, mu }:

let
  pname = "mu4e";
  version = mu.mu4e.version;
in
elpaBuild {
  inherit pname version;

  src = mu.mu4e;

  propagatedUserEnvPkgs = [ mu ];

  dontUnpack = false;

  # prepare a multi-file package tar archive according to info
  # "(elisp) Multi-file Packages" for elpaBuild to install
  postUnpack = ''
    pushd mu-*-mu4e
    local content_directory=${pname}-${version}
    mkdir $content_directory
    cp --verbose share/emacs/site-lisp/mu4e/*.el $content_directory/
    rm --verbose --force $content_directory/mu4e-autoloads.el
    cp --verbose share/info/* $content_directory/
    src=$PWD/$content_directory.tar
    tar --create --verbose --file=$src $content_directory
    popd
  '';

  meta = mu.meta // {
    description = "A full-featured e-mail client";
  };
}
