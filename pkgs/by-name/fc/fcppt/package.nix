{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  catch2_3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fcppt";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "cpreh";
    repo = "fcppt";
    rev = finalAttrs.version;
    hash = "sha256-mPkuMz+PfPA4QkwVpCMPKOCEmaxMg0OfLHAqvH08tUk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    catch2_3
  ];

  cmakeFlags = [
    "-DENABLE_BOOST=true"
    "-DENABLE_EXAMPLES=true"
    "-DENABLE_CATCH=true"
    "-DENABLE_TEST=true"
  ];

  meta = {
    description = "Freundlich's C++ toolkit";
    longDescription = ''
      Freundlich's C++ Toolkit (fcppt) is a collection of libraries focusing on
      improving general C++ code by providing better types, a strong focus on
      C++11 (non-conforming compilers are mostly not supported) and functional
      programming (which is both efficient and syntactically affordable in
      C++11).
    '';
    homepage = "https://fcppt.org";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = [
      "x86_64-linux"
      "x86_64-windows"
    ];
  };
})
