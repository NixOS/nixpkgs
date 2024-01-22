{ lib
, autoreconfHook
, fetchFromGitHub
, stdenv
, wxGTK31
, darwin
, withGui ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gambit-project";
  version = "16.1.1";

  src = fetchFromGitHub {
    owner = "gambitproject";
    repo = "gambit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ElPzJDQ1q+i1OyliychSUA9pT6yGSwjn/sKV0JX5wrQ=";
  };

  nativeBuildInputs =
    [ autoreconfHook ]
    ++ lib.optional withGui wxGTK31;

  buildInputs =
    lib.optional withGui wxGTK31
    ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa;

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature withGui "gui")
  ];

  meta = {
    description = "An open-source collection of tools for doing computation in game theory";
    homepage = "http://www.gambit-project.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
