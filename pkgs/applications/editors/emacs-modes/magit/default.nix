{ stdenv, fetchgit, emacs, texinfo, autoconf, automake }:

let
  version = "0.7-180-gcb458d5";
in
stdenv.mkDerivation {
  name = "magit-${version}";

  src = fetchgit {
    url = "http://git.gitorious.org/magit/mainline.git";
    rev = "cb458d59182a4497b3435090ae71357b6b8c385d";
    sha256 = "1vbafn0drkzhrr6yrgvf62aa9bnk785vavdgsmngjfxql1ngaq2x";
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
