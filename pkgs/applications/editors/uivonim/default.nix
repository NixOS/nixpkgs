{ lib
, buildNpmPackage
, fetchFromGitHub
, electron
, makeWrapper
}:

buildNpmPackage rec {
  pname = "uivonim";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "smolck";
    repo = pname;
    rev = "ac027b4575b7e1adbedde1e27e44240289eebe39";
    sha256 = "1b6k834qan8vhcdqmrs68pbvh4b59g9bx5126k5hjha6v3asd8pj";
  };

  npmDepsHash = "sha256-9oyw09DdjyAjv1IW30715kp0urf/1v754teEtDY1TaI=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  npmFlags = [ "--ignore-scripts" ];

  npmBuildScript = "build:prod";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/uivonim \
      --add-flags $out/lib/node_modules/uivonim/build/main/main.js
  '';

  meta = with lib; {
    homepage = "https://github.com/smolck/uivonim";
    description = "Cross-platform GUI for neovim based on electron";
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
    license = licenses.agpl3Only;
  };
}
