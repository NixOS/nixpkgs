{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  stdenv,
  wxGTK31,
  darwin,
  withGui ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gambit-project";
  version = "16.2.1";

  src = fetchFromGitHub {
    owner = "gambitproject";
    repo = "gambit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2+BW5Lyv1mFJIawAruxNcTU3aB55fekeeq/cJh1mgl4=";
  };

  nativeBuildInputs = [ autoreconfHook ] ++ lib.optional withGui wxGTK31;

  buildInputs =
    lib.optional withGui wxGTK31
    ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.Cocoa;

  strictDeps = true;

  configureFlags = [
    (lib.enableFeature withGui "gui")
  ];

  meta = {
    description = "Open-source collection of tools for doing computation in game theory";
    homepage = "http://www.gambit-project.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ t4ccer ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
