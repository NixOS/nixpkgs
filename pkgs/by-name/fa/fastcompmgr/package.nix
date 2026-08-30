{
  stdenv,
  fetchFromGitHub,
  libxrender,
  libxfixes,
  libxdamage,
  libxcomposite,
  libx11,
  pkgs,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fastcompmgr";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "tycho-kirchner";
    repo = "fastcompmgr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0UEy6Aq007pwI+FRYA9RFjP0XAuBrX0jIbu3L7OcjMo=";
  };

  nativeBuildInputs = [ pkgs.pkg-config ];

  buildInputs = [
    libx11
    libxcomposite
    libxdamage
    libxfixes
    libxrender
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
