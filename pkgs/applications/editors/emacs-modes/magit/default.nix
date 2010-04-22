{stdenv, fetchurl, emacs, texinfo, autoconf, automake}:

let
    version = "0.7-109-g0fc3980";
in
stdenv.mkDerivation {
  name = "magit-${version}";

  src = fetchurl {
    url = "http://cryp.to/magit-mainline-${version}.tar.gz";
    sha256 = "0jyx57znvn49xm0h92kh8iywn44ip130dpflzq2ns2k6gspg36b6";
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
