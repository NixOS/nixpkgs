{stdenv, fetchurl, emacs, texinfo}:

stdenv.mkDerivation {
  name = "magit-0.7";

  src = fetchurl {
    url = "http://zagadka.vm.bytemark.co.uk/magit/magit-0.7.tar.gz";
    sha256 = "0qry1vj41pycwkf71sqrz3zgzh85zdg5acq26asscq4s7jksrjiz";
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
    homepage = "http://zagadka.vm.bytemark.co.uk/magit/";
  };
}
