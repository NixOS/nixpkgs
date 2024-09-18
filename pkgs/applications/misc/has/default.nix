{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation (finalAttrs: rec {
  pname = "has";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "kdabir";
    repo = "has";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TL8VwFx2tf+GkBwz0ILQg0pwcLJSTky57Wx9OW5+lS4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm0555 ${pname} -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/kdabir/has";
    description = "Checks presence of various command line tools and their versions on the path";
    license = licenses.mit;
    maintainers = with maintainers; [ Freed-Wu ];
    platforms = platforms.unix;
    mainProgram = "has";
  };
})
