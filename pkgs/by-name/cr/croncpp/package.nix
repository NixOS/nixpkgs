{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "croncpp";
  version = "2026.08.12";

  src = fetchFromGitHub {
    owner = "mariusbancila";
    repo = "croncpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qdl9494mpmozt6Rmd20MUeGeILWmNGHaxDgW2JnlUvs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++11/14/17 header-only cross-platform library for handling CRON expressions";
    homepage = "https://github.com/mariusbancila/croncpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ typedrat ];
  };
})
