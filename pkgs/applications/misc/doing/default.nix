{ lib, bundlerEnv, ruby
}:

# Bundix:
# nix-shell -p bundix zlib
bundlerEnv rec {
  pname = "doing";
  version = (import ./gemset.nix).doing.version;

  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "A command line tool for keeping track of what you’re doing and tracking what you’ve done.";
    longDescription = ''
      doing is a basic CLI for adding and listing "what was I doing" reminders
      in a TaskPaper-formatted text file. It allows for multiple
      sections/categories and flexible output formatting.
    '';
    homepage    = https://brettterpstra.com/projects/doing/;
    license     = licenses.mit;
    maintainers = with maintainers; [ ktf ];
    platforms   = platforms.unix;
  };
}
