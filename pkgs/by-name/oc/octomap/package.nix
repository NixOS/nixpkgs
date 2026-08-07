{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "octomap";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "OctoMap";
    repo = "octomap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QxQHxxFciR6cvB/b8i0mr1hqGxOXhXmB4zgdsD977Mw=";
  };

  patches = [
    (fetchpatch2 {
      name = "prepare-for-next-patch.patch";
      url = "https://github.com/OctoMap/octomap/commit/c5c714139a82969915b84cd5548dedcd257ebf1e.patch?full_index=1";
      stripLen = 1;
      excludes = [ ".gitignore" ];
      hash = "sha256-p/qvBiqeZt93aI7p7MYG6SUwcRlchHV9AnXKVTzBhRs=";
    })
    # fix for gcc16, merged upstream
    (fetchpatch2 {
      name = "fix-gcc16.patch";
      url = "https://github.com/OctoMap/octomap/commit/d7e54ca1c4074f88381c07bfdd685bd4fced0636.patch?full_index=1";
      stripLen = 1;
      hash = "sha256-8ZwX1CJFykMduEEXIqTRH9VHn7ItvO/ZfdNNDIDmtss=";
    })
  ];

  # ref. https://github.com/OctoMap/octomap/pull/448 not merged yet
  postPatch = ''
    substituteInPlace include/octomap/OcTreeKey.h --replace-fail \
      "#include <ciso646>" ""
  '';

  sourceRoot = "${finalAttrs.src.name}/octomap";

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=deprecated-declarations"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/OctoMap/octomap/releases/tag/${finalAttrs.src.tag}";
    description = "Probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      lopsided98
      nim65s
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
