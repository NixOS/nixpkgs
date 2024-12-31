{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
  xclip,
}:
buildLua (finalAttrs: {
  pname = "smart-copy-paste-2";
  version = "0-unstable-2023-11-25";

  scriptPath = "scripts/SmartCopyPaste_II.lua";
  src = fetchFromGitHub {
    owner = "Eisa01";
    repo = "mpv-scripts";
    rev = "48d68283cea47ff8e904decc9003b3abc3e2123e";
    hash = "sha256-95CAKjBRELX2f7oWSHFWJnI0mikAoxhfUphe9k51Qf4=";
  };

  prePatch = ''
    substituteInPlace scripts/SmartCopyPaste_II.lua \
      --replace-fail 'xclip' "${lib.getExe xclip}"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Smart copy paste with logging and clipboard support";
    homepage = "https://github.com/Eisa01/mpv-scripts";
    license = licenses.bsd2;
    maintainers = with maintainers; [ luftmensch-luftmensch ];
  };
})
