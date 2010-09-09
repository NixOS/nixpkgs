{ stdenv, fetchurl, emacs, texinfo }:

let
  version = "0.8.2";
in
stdenv.mkDerivation {
  name = "magit-${version}";

  src = fetchurl {
    url = "http://github.com/downloads/philjackson/magit/magit-${version}.tar.gz";
    sha256 = "fc02c23e3e8994e9c3e3299d560d0cbfed888dcc66088f06b8cea3bc89cd6ae8";
  };

  buildInputs = [emacs texinfo];

  meta = {
    description = "An an interface to Git, implemented as an extension to Emacs.";

    longDescription = ''
      With Magit, you can inspect and modify your Git repositories with
      Emacs. You can review and commit the changes you have made to the
      tracked files, for example, and you can browse the history of past
      changes. There is support for cherry picking, reverting, merging,
      rebasing, and other common Git operations.

      Magit is not a complete interface to Git; it just aims to make the
      most common Git operations convenient. Thus, Magit will likely not
      save you from learning Git itself.
    '';

    license = "GPLv3+";
    homepage = "http://github.com/philjackson/magit";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
