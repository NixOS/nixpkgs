{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "has";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "kdabir";
    repo = "has";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sqpKI9RHo0VlGUNU71mIzw4LzExji2FN2FBOAIVo4jI=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm0555 has -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/kdabir/has";
    description = "Checks presence of various command line tools and their versions on the path";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Freed-Wu ];
    platforms = lib.platforms.unix;
    mainProgram = "has";
  };
})
