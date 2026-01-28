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
    hash = "sha256-yTLSCJ9TpTfe5jThBY7nivT9pQwjvmHMp6IUZLCg9kk=";
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
