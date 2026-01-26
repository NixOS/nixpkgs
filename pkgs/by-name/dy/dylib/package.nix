{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dylib";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "martin-olivier";
    repo = "dylib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ub45d7KDcN0d/3CXgvyZoLQfHM72m1p4ggvF9ibR9No=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DDYLIB_BUILD_TESTS=OFF"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ cross-platform wrapper around dynamic loading of shared libraries";
    homepage = "https://github.com/martin-olivier/dylib";
    changelog = "https://github.com/martin-olivier/dylib/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ ZZBaron ];
  };
})
