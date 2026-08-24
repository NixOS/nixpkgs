{
  lib,
  stdenv,
  fetchFromGitHub,
  rofi,
  systemd,
  coreutils,
  util-linux,
  gawk,
  makeWrapper,
  jq,
}:

stdenv.mkDerivation rec {
  pname = "rofi-systemd";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "colonelpanic8";
    repo = "rofi-systemd";
    tag = "v${version}";
    sha256 = "sha256-Ry7GRd1e5OvkfB9O0QWtd+cMpmU1qv6kYQ/wx01lrI0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a rofi-systemd $out/bin/rofi-systemd
  '';

  wrapperPath = lib.makeBinPath [
    coreutils
    gawk
    jq
    rofi
    systemd
    util-linux
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/rofi-systemd --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "Control your systemd units using rofi";
    homepage = "https://github.com/colonelpanic8/rofi-systemd";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
    mainProgram = "rofi-systemd";
  };
}
