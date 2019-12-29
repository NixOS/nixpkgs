{ stdenv, fetchFromGitHub, vim, makeWrapper, jq, rofi, xrandr, xdotool, i3, gawk, libnotify }:

let
  path = stdenv.lib.makeBinPath [ vim jq rofi xrandr xdotool i3 gawk libnotify ];
in

stdenv.mkDerivation rec {
  pname = "i3-layout-manager";
  version = "unstable-2019-06-19";

  src = fetchFromGitHub {
    owner = "klaxalk";
    repo = pname;
    rev = "80ade872bfd70d9c6039024097ceb8c852a2816a";
    sha256 = "02xhyd737qwni628mjzr9i5v2kga5cq4k8m77bxm1p6kkj84nlmg";
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
