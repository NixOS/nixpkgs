{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rofi,
  systemd,
  coreutils,
  util-linux,
  gawk,
  makeWrapper,
  jq,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rofi-systemd";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "colonelpanic8";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    sha256 = "13dccm6wgw0gc6jgxaimcnk0rrvpml2x2khzgkjfpr2yvm2wcbj7";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 rofi-systemd $out/bin/rofi-systemd

    runHook postInstall
  '';

  wrapperPath = lib.makeBinPath [
    coreutils
    gawk
    jq
    rofi
    systemd
    util-linux
  ];

  postFixup = ''
    wrapProgram $out/bin/rofi-systemd --prefix PATH : "${finalAttrs.wrapperPath}"
  '';

  meta = {
    description = "Control your systemd units using rofi";
    homepage = "https://github.com/colonelpanic8/rofi-systemd";
    maintainers = [ lib.maintainers.imalison ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = finalAttrs.pname;
  };
})
