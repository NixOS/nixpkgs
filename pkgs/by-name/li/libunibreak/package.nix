{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  version ? "8.0.1",
  hash ? "sha256-CjwdIuh2X4dLgSdGrMtnqZPPzOj59We+TI/WJ3bntrY=",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libunibreak";
  inherit version;
  __structuredAttrs = true;
  strictDeps = true;

  src =
    let
      rev_version = lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
    in
    fetchFromGitHub {
      owner = "adah1972";
      repo = "libunibreak";
      tag = "libunibreak_${rev_version}";
      inherit hash;
    };

  nativeBuildInputs = [ autoreconfHook ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/adah1972/libunibreak";
    changelog = "https://github.com/adah1972/libunibreak/blob/${finalAttrs.src.tag}/NEWS";
    description = "Implementation of line breaking and word breaking algorithms as in the Unicode standard";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ gaelj ];
  };
})
