{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp rec {
  pname = "sublime_syntax_convertor";
  gemdir = ./.;
  exes = [ "sublime_syntax_convertor" ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = {
    description = "Converts tmLanguage to sublime-syntax";
    homepage = "https://github.com/aziz/SublimeSyntaxConvertor/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ laalsaas ];
  };
}
