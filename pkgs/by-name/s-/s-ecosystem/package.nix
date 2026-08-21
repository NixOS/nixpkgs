{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "s-ecosystem";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hubbydenny";
    repo = "S-ecosystem";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail "g++" "${stdenv.cc}/bin/g++"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 sfetch $out/bin/sfetch
    install -Dm755 scat $out/bin/scat
    install -Dm755 sls $out/bin/sls
    runHook postInstall
  '';

  meta = {
    description = "Shell utilities: sfetch, scat, sls";
    homepage = "https://github.com/hubbydenny/S-ecosystem";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sfetch";
    maintainers = [ ];
  };
});
