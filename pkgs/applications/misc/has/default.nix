{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation (finalAttrs: rec {
  pname = "has";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "kdabir";
    repo = "has";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3XsNSl4lQfJjEPNGoFj6ABXGkwOUsg9AFDAz8euZApE=";
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
  };
})
