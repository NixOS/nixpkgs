{
  stdenv,
  fetchFromGitHub,
  xorg,
  pkgs,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastcompmgr";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "tycho-kirchner";
    repo = "fastcompmgr";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-yH/+E2IBe9KZxKTiP8oNcb9fJcZ0ukuenqTSv97ed44=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];

  buildInputs = [
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrender
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp fastcompmgr $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Fast compositor for X11";
    homepage = "https://github.com/tycho-kirchner/fastcompmgr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ camerondugan ];
    platforms = lib.platforms.linux;
  };
})
