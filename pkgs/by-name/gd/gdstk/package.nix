{ lib, stdenv, fetchFromGitHub, cmake, zlib, qhull, python3Packages, ... }:

# Since gdstk is primarily a Python package, we use the specific build function.
with python3Packages;

buildPythonPackage rec {
  pname = "gdstk";
  version = "0.9.61"; # Make sure this is the version you intend to package

  format = "other";

  src = fetchFromGitHub {
    owner = "heitzmann";
    repo = "gdstk";
    rev = "v${version}";
    # !! IMPORTANT !! 
    # REPLACE THIS HASH. Nix will tell you the correct one if the build fails,
    # or you can prefetch it.
    hash = "sha256-soU+6EbyOkHGvVq230twiRzywOskhkkXFr5akBpvgBw="; 
  };
  
  # Dependencies for the C++ library (which the Python module links against)
  buildInputs = [ zlib qhull ];

  # Build tools needed for the C++ parts (CMake)
  nativeBuildInputs = [ cmake ];

  # Dependencies required by the Python module at runtime
  propagatedBuildInputs = [ numpy ]; 

  # The meta attributes are crucial for Nixpkgs acceptance
  meta = with lib; {
    # Short, capitalized sentence, no trailing period.
    description = "C++ library and Python module for creation and manipulation of GDSII and OASIS files"; 
    homepage = "https://github.com/heitzmann/gdstk";
    license = licenses.bsl11; # Boost Software License 1.0 (BSL-1.0)
    # Add your maintainer handle (e.g., maintainers.gonsolo)
    maintainers = with maintainers; [ ]; 
  };
}
