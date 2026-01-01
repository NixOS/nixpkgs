{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "paperkey";
  version = "1.6";

  src = fetchurl {
    url = "https://www.jabberwocky.com/software/paperkey/${pname}-${version}.tar.gz";
    sha256 = "1xq5gni6gksjkd5avg0zpd73vsr97appksfx0gx2m38s4w9zsid2";
  };

  postPatch = ''
    for a in checks/*.sh ; do
      substituteInPlace $a \
        --replace /bin/echo echo
    done
  '';

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Store OpenPGP or GnuPG on paper";
    mainProgram = "paperkey";
    longDescription = ''
      A reasonable way to achieve a long term backup of OpenPGP (GnuPG, PGP, etc)
      keys is to print them out on paper. Paper and ink have amazingly long
      retention qualities - far longer than the magnetic or optical means that
      are generally used to back up computer data.
    '';
    homepage = "https://www.jabberwocky.com/software/paperkey/";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
=======
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      peterhoeg
    ];
  };
}
