{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ponyc,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corral";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "corral";
    rev = finalAttrs.version;
    hash = "sha256-WblwyUm7mTdh3GvuSvO9bW6txbJeSS4qrvP4TeYk1uw=";
  };

  patches = [
    # Should be in the next release, fixes compile on newer versions
    (fetchpatch {
      url = "https://github.com/ponylang/corral/commit/10b85e36e5c7ec4503ecb80ff51aa2342e459805.patch";
      hash = "sha256-wDvoW1t/F3ieNlwS+HtxVzhlFX4TDTbAnxJnJnsCvtc=";
      includes = [ "corral/semver/version/compare_versions.pony" ];
    })
  ];

  env.arch =
    if stdenv.hostPlatform.isx86_64 then
      "x86-64"
    else if stdenv.hostPlatform.isAarch64 then
      "generic"
    else
      lib.warn ''
        architecture '${stdenv.hostPlatform.system}' compiles with native optimizations,
        this may result in crashes on incompatible CPUs!
      '' "native";

  strictDeps = true;

  nativeBuildInputs = [ ponyc ];

  installFlags = [
    "prefix=${placeholder "out"}"
    "install"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    changelog = "https://github.com/ponylang/corral/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      redvers
      numinit
    ];
    inherit (ponyc.meta) platforms;
  };
})
