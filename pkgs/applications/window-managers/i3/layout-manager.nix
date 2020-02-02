{ stdenv, fetchFromGitHub, vim, makeWrapper, jq, rofi, xrandr, xdotool, i3, gawk, libnotify }:

let
  path = stdenv.lib.makeBinPath [ vim jq rofi xrandr xdotool i3 gawk libnotify ];
in

stdenv.mkDerivation rec {
  pname = "i3-layout-manager";
  version = "unstable-2019-12-06";

  src = fetchFromGitHub {
    owner = "klaxalk";
    repo = pname;
    rev = "064e13959413ba2d706185478a394e5852c0dc53";
    sha256 = "1qm35sp1cfi3xj5j7xwa05dkb3353gwq4xh69ryc6382xx3wszg6";
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

  meta = with stdenv.lib; {
    homepage = https://github.com/klaxalk/i3-layout-manager;
    description = "Saving, loading and managing layouts for i3wm.";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
