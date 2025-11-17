{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "croncpp";
  version = "2023.03.30";

  src = fetchFromGitHub {
    owner = "mariusbancila";
    repo = "croncpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SBjNzy54OGEMemBp+c1gaH90Dc7ySL915z4E64cBWTI=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++11/14/17 header-only cross-platform library for handling CRON expressions";
    homepage = "https://github.com/mariusbancila/croncpp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ typedrat ];
  };
})
