{
  clangStdenv,
  fetchFromGitHub,
  gnustep-back,
  lib,
  wrapGNUstepAppsHook,
}:

clangStdenv.mkDerivation {
  strictDeps = true;
  __structuredAttrs = true;
  name = "gershwin-textedit";
  version = "4-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "gershwin-desktop";
    repo = "gershwin-textedit";
    rev = "f77e874b3bed709267885cdd24aeeb8711a407b0";
    hash = "sha256-b4a/ywmwzXjmi4Y8RaDaPZlHXt5pa/4VqUw8Izt8N38=";
  };

  nativeBuildInputs = [
    wrapGNUstepAppsHook
  ];

  buildInputs = [
    gnustep-back
  ];

  meta = {
    homepage = "https://github.com/gershwin-desktop/gershwin-textedit";
    description = "The text editor for Gershwin Desktop";
    license = lib.licenses.mit;
    mainProgram = "TextEdit";
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
  };
  platforms = lib.platforms.linux;
}
