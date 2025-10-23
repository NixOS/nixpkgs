{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libminc,
}:

stdenv.mkDerivation {
  pname = "ebtks";
  version = "unstable-2017-09-23";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "EBTKS";
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

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/EBTKS";
    description = "Library for working with MINC files";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.free;
  };
}
