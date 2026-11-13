{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "doing";
  exes = lib.singleton "doing";

  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "doing";

  meta = {
    description = "Command line tool for keeping track of what you’re doing and tracking what you’ve done";
    longDescription = ''
      doing is a basic CLI for adding and listing "what was I doing" reminders
      in a TaskPaper-formatted text file. It allows for multiple
      sections/categories and flexible output formatting.
    '';
    homepage = "https://brettterpstra.com/projects/doing/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ktf
      nicknovitski
    ];
    platforms = lib.platforms.unix;
    mainProgram = "doing";
  };
}
