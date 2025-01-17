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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "IvanMalison";
    repo = "rofi-systemd";
    rev = "v${version}";
    sha256 = "0lgffb6rk1kf91j4j303lzpx8w2g9zy2gk99p8g8pk62a30c5asm";
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
    homepage = "https://github.com/IvanMalison/rofi-systemd";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; linux;
    mainProgram = "rofi-systemd";
  };
}
