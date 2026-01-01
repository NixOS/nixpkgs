{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
<<<<<<< HEAD
  catch2_3,
}:
stdenv.mkDerivation rec {
  pname = "fcppt";
  version = "5.0.0";
=======
  catch2,
}:
stdenv.mkDerivation rec {
  pname = "fcppt";
  version = "4.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "freundlich";
    repo = "fcppt";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-8dBG6LdSngsutBboqb3WVVg3ylayoUYDOJV6p/ZFkoE=";
=======
    sha256 = "1pcmi2ck12nanw1rnwf8lmyx85iq20897k6daxx3hw5f23j1kxv6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
<<<<<<< HEAD
    catch2_3
=======
    catch2
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  cmakeFlags = [
    "-DENABLE_BOOST=true"
    "-DENABLE_EXAMPLES=true"
    "-DENABLE_CATCH=true"
    "-DENABLE_TEST=true"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Freundlich's C++ toolkit";
    longDescription = ''
      Freundlich's C++ Toolkit (fcppt) is a collection of libraries focusing on
      improving general C++ code by providing better types, a strong focus on
      C++11 (non-conforming compilers are mostly not supported) and functional
      programming (which is both efficient and syntactically affordable in
      C++11).
    '';
    homepage = "https://fcppt.org";
<<<<<<< HEAD
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ pmiddend ];
=======
    license = licenses.boost;
    maintainers = with maintainers; [ pmiddend ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "x86_64-linux"
      "x86_64-windows"
    ];
  };
}
