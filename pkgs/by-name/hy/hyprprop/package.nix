{ fetchFromGitHub
, socat
, jq
, lib
, makeWrapper
, slurp
, stdenv
, hyprland
, hyprevents
, bash
}:

stdenv.mkDerivation {
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
  installPhase = ''
    runHook preInstall

    export PREFIX="$out"
    make install

    wrapProgram "$out/bin/hyprprop" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ socat jq slurp hyprland hyprevents ]}"

    runHook postInstall
  '';
  passthru.scriptName = "hyprprop";

  meta = with lib; {
    description = "xprop for Hyprland";
    homepage = "https://github.com/vilari-mickopf/hyprprop";
    maintainers = with maintainers; [ pacificviking ];
    platforms = platforms.linux;
    mainProgram = "hyprprop";
  };
}
