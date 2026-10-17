{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcsptr";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "libcsptr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kMUBNVKYMf5WtLCYcFKxeZlN3+FxuD+sG/ibKCBKJEQ=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  meta = {
    description = "Smart pointer constructs for the (GNU) C programming language";
    homepage = "https://github.com/Snaipe/libcsptr";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.fragamus ];
  };
})
