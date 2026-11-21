{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libytnef";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "Yeraze";
    repo = "ytnef";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DzHJjxsSEgVx6iqVzsiQ1v4hf0pu+hJueEJGWhfkX9o=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Yeraze's TNEF Stream Reader - for winmail.dat files";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
