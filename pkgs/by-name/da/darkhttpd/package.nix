{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "darkhttpd";
  version = "1.17";

  src = fetchFromGitHub {
    owner = "emikulic";
    repo = "darkhttpd";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-d5pDUY1EbVjykb4in4hhbgbjIXJtj133nRAQ84ASicQ=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin darkhttpd
    install -Dm444 -t $out/share/doc/darkhttpd README.md
    head -n 18 darkhttpd.c > $out/share/doc/darkhttpd/LICENSE
    runHook postInstall
  '';

  meta = {
    description = "Small and secure static webserver";
    mainProgram = "darkhttpd";
    homepage = "https://unix4lyfe.org/darkhttpd/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bobvanderlinden ];
    platforms = lib.platforms.all;
  };
})
