{ lib,bundlerApp }:
bundlerApp {
  pname = "sublime_syntax_convertor";
  gemdir = ./.;
  exes = [ "sublime_syntax_convertor" ];

  meta = {
    description = "Converts tmLanguage to sublime-syntax";
    homepage = "https://github.com/aziz/SublimeSyntaxConvertor/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ laalsaas ];
  };
}
