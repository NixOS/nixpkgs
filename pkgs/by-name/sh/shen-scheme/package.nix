{
  chez,
  fetchurl,
  lib,
  libuuid,
  lz4,
  nix-update-script,
  stdenv,
  zlib,
}:
# necessary to match the makefile's expectations for pre-built chez and prevent
# linker errors for ncurses and libiconv
let
  custom-chez = chez.override {
    enableCurses = false;
    enableIconv = false;
    enableX11 = false;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shen-scheme";
  version = "0.50";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/tizoc/shen-scheme/releases/download/v${finalAttrs.version}/shen-scheme-v${finalAttrs.version}-src.tar.gz";
    hash = "sha256-KVnulbS9g+AqiPEiDMSFf2bFWHpZKKvJ9+DRcTZHGYY=";
  };

  strictDeps = true;
  enableParallelBuilding = true;
  dontStrip = true; # necessary to prevent runtime errors with chez

  nativeBuildInputs = [
    custom-chez
  ];
  buildInputs = [
    lz4
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libuuid;

  makeFlags = [
    "prefix=$(out)"

    "csbinpath=${lib.getBin custom-chez}/bin"
    "csboot=$(csbootpath)$(S)scheme.boot"
    "csbootpath=$(csdir)$(S)$(m)"
    "csdir=${custom-chez}/lib/csv${custom-chez.version}"
    "cskernel="
    "csversion=${custom-chez.version}"
    "psboot=$(csbootpath)$(S)petite.boot"

    "lz4="
    "zlib="
    "lz4dir=${lib.getLib lz4}/lib"
    "zlibdir=${lib.getLib zlib}/lib"

    # maximum chez optimization for the shen/scheme runtime
    "SHEN_SCHEME_OPTIMIZE_LEVEL=3"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    result="$("$out/bin/shen-scheme" eval -e "(+ 1 2)")"
    test "$result"="3"

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tizoc/shen-scheme";
    description = "A Scheme port of the Shen language";
    changelog = "https://github.com/tizoc/shen-scheme/blob/v${finalAttrs.version}/CHANGELOG.md";
    platforms = custom-chez.meta.platforms;
    maintainers = with lib.maintainers; [ hakujin ];
    license = lib.licenses.bsd3;
    mainProgram = "shen-scheme";
  };
})
