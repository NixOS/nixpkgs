{
  stdenv,
  pname,
  version,
  meta,
  undmg,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl {
    url = "https://proton.me/download/PassDesktop/darwin/universal/ProtonPass_${version}.dmg";
    hash = "sha256-oo02IYOKZEsr0+4zimSFkutTGuS63ZvMZTeUTapZrVw=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';
})
