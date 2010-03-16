{stdenv, fetchurl, emacs, texinfo, autoconf, automake}:

stdenv.mkDerivation {
  name = "magit-0.7-94-gbf42bf8";

  src = fetchurl {
    url = "http://gitorious.org/magit/mainline/archive-tarball/magit_0.7-94-gbf42bf8";
    sha256 = "6543a4e312d1a4249ff1edd192914d02f1a9016c321c8fdd0f015074e522759a";
  };
  unpackCmd = "tar xf $src";
  preConfigure = "./autogen.sh";

  buildInputs = [emacs texinfo autoconf automake];

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
    homepage = "http://zagadka.vm.bytemark.co.uk/magit/";
  };
}
