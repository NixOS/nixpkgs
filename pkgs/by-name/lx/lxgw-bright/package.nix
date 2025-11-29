{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

let
  pname = "lxgw-bright";
  version = "5.527";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lxgw";
    repo = "LxgwBright";
    rev = "v${version}";
    hash = "sha256-c03ZG1j5CyMQx8wJB2jhjCT/+I4jKKfwqt9wt0hMnTE=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 LXGWBright/*.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/lxgw/LxgwBright";
    description = "A merged font of Ysabeau and LXGW WenKai.";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ chlorine ];
  };
}
