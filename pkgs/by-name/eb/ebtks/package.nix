{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libminc,
}:

stdenv.mkDerivation {
  pname = "ebtks";
<<<<<<< HEAD
  version = "1.6.40-unstable-2025-05-06";
=======
  version = "unstable-2017-09-23";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "EBTKS";
<<<<<<< HEAD
    rev = "7317b54d79bd7d80b5361dc44a7966709d9a8b36";
    hash = "sha256-kp3uPvsIker8918stsVUdMC72A6Jz0K7r5PFDLbWqNo=";
  };

=======
    rev = "67e4e197d8a32d6462c9bdc7af44d64ebde4fb5c";
    hash = "sha256-+MIRE2NdRH7IQrstK3WRqft6l9I+UGD6j0G7Q6LhOKg=";
  };

  # error: use of undeclared identifier 'finite'; did you mean 'isfinite'?
  postPatch = ''
    substituteInPlace templates/EBTKS/SimpleArray.h \
      --replace "#define FINITE(x) finite(x)" "#define FINITE(x) isfinite(x)"
  ''
  # error: ISO C++17 does not allow 'register' storage class specifier
  + ''
    find . -type f -exec sed -i -e 's/register //g' {} +
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/BIC-MNI/EBTKS";
    description = "Library for working with MINC files";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
=======
  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/EBTKS";
    description = "Library for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
