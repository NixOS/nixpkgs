{
  stdenv,
  lib,
  fetchzip,
  openssl,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableManpages ? false,
  pandoc,
}:

stdenv.mkDerivation rec {
  pname = "fsverity-utils";
  version = "1.6";

  outputs = [
    "out"
    "lib"
    "dev"
  ]
  ++ lib.optional enableManpages "man";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/fs/fsverity/fsverity-utils.git/snapshot/fsverity-utils-v${version}.tar.gz";
    sha256 = "sha256-FZN4MKNmymIXZ2Q0woA0SLzPf4SaUJkj4ssKPsY4xXc=";
  };

  patches = lib.optionals (!enableShared) [
    ./remove-dynamic-libs.patch
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = lib.optional enableManpages pandoc;
  buildInputs = [ openssl ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ]
  ++ lib.optional enableShared "USE_SHARED_LIB=1";

  doCheck = true;

  installTargets = [ "install" ] ++ lib.optional enableManpages "install-man";

  postInstall = ''
    mkdir -p $lib
    mv $out/lib $lib/lib
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#userspace-utility";
    changelog = "https://git.kernel.org/pub/scm/fs/fsverity/fsverity-utils.git/tree/NEWS.md";
    description = "Set of userspace utilities for fs-verity";
    mainProgram = "fsverity";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jk ];
    platforms = lib.platforms.linux;
=======
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
