{
  fetchFromCodeberg,
  fieldSize ? 2048,
  lib,
  stdenv,
  useAssemblyBackendIfAvailable ? true,
  nix-update-script,
}:
let
  filename = "libhighctidh_${toString fieldSize}.so";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libhighctidh_${toString fieldSize}";
  version = "1.0.2025051200";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "vula";
    repo = "highctidh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wGJv9UHAFfCOpTrr8THVk0DC+JUtj3gYYOf6o3EaSqg=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  buildFlags = [ filename ];

  doCheck = true;
  checkTarget = lib.concatStringsSep " " [
    "testrandom"
    "test${toString fieldSize}"
  ];

  installPhase = ''
    $preInstall

    mkdir -p $out/include/libhighctidh
    cp *.h $out/include/libhighctidh

    mkdir -p $out/lib
    cp ${filename} $out/lib

    $postInstall
  '';

  env =
    lib.optionalAttrs (!useAssemblyBackendIfAvailable) {
      HIGHCTIDH_PORTABLE = "1";
    }
    // lib.optionalAttrs stdenv.cc.isGNU {
      NIX_CFLAGS_COMPILE = "-Wno-error=maybe-uninitialized";
    };

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://codeberg.org/vula/highctidh";
    description = "high-ctidh fork as a portable shared library";
    maintainers = with lib.maintainers; [ mightyiam ];
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
  };
})
