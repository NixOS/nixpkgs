{
  lib,
  elpaBuild,
  mu,
}:

elpaBuild {
  pname = "mu4e";
  version = mu.mu4e.version;

  src = mu.mu4e;

  propagatedUserEnvPkgs = [ mu ];

  dontUnpack = false;

  # prepare a multi-file package tar archive according to info
  # "(elisp) Multi-file Packages" for elpaBuild to install
  postBuild = ''
    local content_directory=$pname-$version
    mkdir $content_directory
    cp --verbose share/emacs/site-lisp/mu4e/*.el $content_directory/
    rm --verbose --force $content_directory/mu4e-autoloads.el
    cp --verbose share/info/* $content_directory/
    src=$PWD/$content_directory.tar
    tar --create --verbose --file=$src $content_directory
  '';

  ignoreCompilationError = false;

  meta = removeAttrs mu.meta [ "mainProgram" ] // {
    description = "Full-featured e-mail client";
    maintainers = mu.meta.maintainers ++ (with lib.maintainers; [ linj ]);
  };
}
