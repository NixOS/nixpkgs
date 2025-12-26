{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  glib,
  gsl,
  libdivsufsort,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "andi";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "evolbioinf";
    repo = "andi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tjQ9exFyqu/xnbUGpF6k0kE5C1D93kISjRErwHfjW9E=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gsl
    libdivsufsort
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  configureFlags = [ (lib.enableFeature finalAttrs.finalPackage.doCheck "unit-tests") ];

  nativeCheckInputs = [ glib ];

  doCheck = true;

  preCheck = ''
    patchShebangs ./test
  '';

  meta = {
    description = "Efficient Estimation of Evolutionary Distances";
    homepage = "https://github.com/evolbioinf/andi";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "andi";
    platforms = lib.platforms.all;
  };
})
