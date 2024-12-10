{ lib, stdenv, fetchFromGitHub, vim, makeWrapper, jq, rofi, xrandr, xdotool, i3, gawk, libnotify }:

let
  path = lib.makeBinPath [ vim jq rofi xrandr xdotool i3 gawk libnotify ];
in

stdenv.mkDerivation rec {
  pname = "i3-layout-manager";
  version = "unstable-2020-05-04";

  src = fetchFromGitHub {
    owner = "klaxalk";
    repo = pname;
    rev = "df54826bba351d8bcd7ebeaf26c07c713af7912c";
    sha256 = "0ccvr43yp26fnh5d82cw7jcfq2sbxzzmdx2cp15bmxr8ixr8knc3";
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

  meta = with lib; {
    homepage = "https://github.com/klaxalk/i3-layout-manager";
    description = "Saving, loading and managing layouts for i3wm";
    mainProgram = "layout_manager";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
