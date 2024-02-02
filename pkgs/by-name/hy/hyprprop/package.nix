{ fetchFromGitHub
, socat
, jq
, lib
, makeWrapper
, slurp
, stdenvNoCC
, hyprland
, hyprevents
, bash
}:

stdenvNoCC.mkDerivation {
  # pkill is a dependency here.. but its in PATH and its hyprevents (not hyprprop) that needs to access it...
  pname = "hyprprop";
  version = "unstable-2024-01-15";

  src = fetchFromGitHub {
    owner = "vilari-mickopf";
    repo = "hyprprop";
    rev = "46d12dbc002917917a79c59bcaefd5e2b3901898";
    hash = "sha256-J3GM+o+kcp1rprWREJTSUbIPZheoPOu2wT43/GaO7oA=";
  };

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontBuild = true;
  makeFlags = [
    "PREFIX=$(out)"
  ];

  postInstall = ''
    wrapProgram "$out/bin/hyprprop" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ socat jq slurp hyprland hyprevents ]}"
  '';

  meta = with lib; {
    description = "xprop for Hyprland";
    homepage = "https://github.com/vilari-mickopf/hyprprop";
    maintainers = with maintainers; [ pacificviking ];
    platforms = platforms.linux;
    mainProgram = "hyprprop";
  };
}
