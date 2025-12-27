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
    hash = "sha256-JdlpkYC5UAufirulzmqW1U8sxp7hcE6/dFARnTDDtq4=";
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
