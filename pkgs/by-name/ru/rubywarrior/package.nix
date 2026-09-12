{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

(bundlerApp rec {
  pname = "rubywarrior";

  inherit ruby;

  gemdir = ./.;

  exes = [
    pname
  ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = with lib; {
    description = "Game written in Ruby for learning Ruby.";
    homepage = "https://github.com/ryanb/ruby-warrior";
    license = licenses.mit;
    maintainers = [ lib.maintainers.ferguscollins ];
    mainProgram = pname;
    platforms = platforms.unix;
  };
}).overrideAttrs
  (_: {
    # below 2 lines required for new packages
    __structuredAttrs = true;
    strictDeps = true;
  })
