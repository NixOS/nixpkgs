{
  lib,
  stdenv,
  fetchFromGitHub,
  vim,
  makeWrapper,
  jq,
  rofi,
  xrandr,
  xdotool,
  i3,
  gawk,
  libnotify,
}:

let
  path = lib.makeBinPath [
    vim
    jq
    rofi
    xrandr
    xdotool
    i3
    gawk
    libnotify
  ];
in

stdenv.mkDerivation {
  pname = "i3-layout-manager";
  version = "unstable-2020-05-04";

  src = fetchFromGitHub {
    owner = "klaxalk";
    repo = "i3-layout-manager";
    rev = "df54826bba351d8bcd7ebeaf26c07c713af7912c";
    hash = "sha256-g9mJco8o97pKuEz0Vv/vSwvsmDycCdQKtM6I6wfJmzE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D layout_manager.sh $out/bin/layout_manager
    wrapProgram $out/bin/layout_manager \
      --prefix PATH : "${path}"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/klaxalk/i3-layout-manager";
    description = "Saving, loading and managing layouts for i3wm";
    mainProgram = "layout_manager";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
