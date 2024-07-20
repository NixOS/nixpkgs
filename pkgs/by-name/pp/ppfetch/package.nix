{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ppfetch";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "yael333";
    repo = "ppfetch";
    rev = finalAttrs.version;
    hash = "sha256-cyBBOIXRXTydPmA/sGTRu9ktXGj+KLE6r6b7PqoAa50=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -Dm555 -t $out/bin ppfetch
  '';

  meta = with lib; {
    description = "Colorful and prideful system info tool";
    homepage = "https://github.com/yael333/ppfetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ yael ];
    mainProgram = "ppfetch";
  };
})
