{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  libuuid,
  zlib,
}:

stdenv.mkDerivation {
  # The files and commit messages in the repository refer to the package
  # as ssdfs-utils, not ssdfs-tools.
  pname = "ssdfs-utils";
  # The version is taken from `configure.ac`, there are no tags.
<<<<<<< HEAD
  version = "4.65";
=======
  version = "4.64";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dubeyko";
    repo = "ssdfs-tools";
<<<<<<< HEAD
    rev = "256c3415a580c2bec37f98bdc6d972c10454d627";
    hash = "sha256-HGT7hBzsbtlBud4zwWZHDrQqzA1lmnNMrCZy5oylBSQ=";
=======
    rev = "46ef1ea7baa81fb009b4010700a9e00c39fb61a8";
    hash = "sha256-ky0+UKqIF37tf0drNRvdi116VZsgUn2HedPeKuitHLg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libtool
    libuuid
    zlib
  ];

  passthru = {
    updateScript = ./update.sh;
  };

<<<<<<< HEAD
  meta = {
    description = "SSDFS file system utilities";
    homepage = "https://github.com/dubeyko/ssdfs-tools";
    license = lib.licenses.bsd3Clear;
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "SSDFS file system utilities";
    homepage = "https://github.com/dubeyko/ssdfs-tools";
    license = licenses.bsd3Clear;
    maintainers = with maintainers; [ ners ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
