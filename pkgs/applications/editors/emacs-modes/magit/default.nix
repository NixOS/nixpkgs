{ stdenv, fetchurl, emacs, texinfo }:

let
  version = "1.1.1";
in
stdenv.mkDerivation {
  name = "magit-${version}";

  src = fetchurl {
    url = "http://github.com/downloads/magit/magit/magit-${version}.tar.gz";
    sha256 = "0zp5qxippmalin2fr73w2alf2w7ilcahmybzdvgn4ch2s3dgvzcz";
  };

  buildInputs = [emacs texinfo];

  configurePhase = "makeFlagsArray=( PREFIX=$out SYSCONFDIR=$out/etc )";

  meta = {
    description = "Magit, an Emacs interface to Git";

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
    homepage = "https://github.com/magit/magit";
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ simons ludo ];
  };
}
