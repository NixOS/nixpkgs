{
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  lib,
  cmake,
  u-config,
  gtkmm3,
  gtksourceviewmm,
  gtksourceview3,
  jsoncpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notekit";
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "blackhole89";
    repo = "${finalAttrs.pname}";
    rev = "f53fa3b999cdd7a5efe264301eaadfdb7e969553";
    sha256 = "sha256-lXCwvDw7j7mPryqN7OI7jkneuBoNoLbNUP+Vm/q32RI=";
  };

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  nativeBuildInputs = [
    u-config
    cmake
    wrapGAppsHook3
  ];

  buildInputs = [
    gtkmm3
    gtksourceviewmm
    jsoncpp
    gtksourceview3
  ];

  meta = {
    homepage = "https://github.com/blackhole89/${finalAttrs.pname}";
    description = "Hierarchical markdown notetaking application with tablet support";
    maintainers = [ lib.maintainers.philocalyst ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux ++ darwin;
  };
})
