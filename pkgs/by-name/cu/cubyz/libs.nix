{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig_0_16,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "12";
  pname = "cubyz-libs";
  src = fetchFromGitHub {
    owner = "pixelguys";
    repo = "cubyz-libs";
    tag = finalAttrs.version;
    hash = "sha256-ATOsUY2RWKXremtgqoNQb4FEhIXdm1h076ChiriyyUE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-5I3KM9yWJlE8ivVjXlVSKSrlMcBk9f09yQnCNVaml8U=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig_0_16.hook
  ];

  zigBuildFlags = [
    "-Doptimize=ReleaseSafe"
  ];

  meta = {
    homepage = "https://github.com/PixelGuys/Cubyz-libs";
    description = "Contains libraries used in Cubyz";
    platforms = lib.platforms.linux;
    mainProgram = "cubyz";
    maintainers = with lib.maintainers; [ leha44581 ];
  };
})
