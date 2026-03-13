{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
  xdotool,
}:

buildNpmPackage {
  pname = "cs2-chat-translator";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "MeckeDev";
    repo = "cs2-chat-translator";
    rev = "main"; # besser: Tag wie v0.1.0, wenn du einen setzt
    sha256 = "sha256-KgWLpuUe4vyTNS89NnN2GtQsyGraCMuKgv91zNPdVoQ=";
  };

  npmDepsHash = "sha256-P4NEXFda+U1V6NXL9dv2H0uEcwbV8jKgpWorP8vRB68=";

  nodejs = nodejs_20;
  buildInputs = [ xdotool ];

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/cs2-chat-translator
    mkdir -p $out/bin

    cp -r . $out/lib/node_modules/cs2-chat-translator

    ln -s $out/lib/node_modules/cs2-chat-translator/bin/cs2-chat-translator.js \
          $out/bin/cs2-chat-translator

    runHook postInstall
  '';

  meta = with lib; {
    description = "CS2 chat translator (Node.js + xdotool + google-translate-api-x).";
    homepage = "https://github.com/MeckeDev/cs2-chat-translator";
    license = licenses.mit;
    platforms = platforms.linux;
    # optional, wenn du dich als Maintainer in nixpkgs einträgst:
    # maintainers = with maintainers; [ meckeDev ];
  };
}
