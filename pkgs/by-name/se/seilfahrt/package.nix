{ lib
, buildGoModule
, fetchFromGitHub
, pandoc
}:

buildGoModule rec {
  pname = "seilfahrt";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Nerdbergev";
    repo = "seilfahrt";
    rev = "v${version}";
    hash = "sha256-w3r/mNb4en32huHjJbYghqDi/VsPGXinwUAfSMcuc+0=";
  };

  vendorHash = "sha256-wYxQHr8AVi5KGMqRJcb2rTtbnJbi5som29YSILlO6Po=";

  buildInputs = [ pandoc ];

  meta = with lib; {
    description = "Tool to create a wiki page from a HedgeDoc";
    homepage = "https://github.com/Nerdbergev/seilfahrt";
    changelog = "https://github.com/Nerdbergev/seilfahrt/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ xgwq ];
    mainProgram = "seilfahrt";
  };
}
