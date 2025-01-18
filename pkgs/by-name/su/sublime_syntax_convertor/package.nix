{ lib, bundlerApp }:
bundlerApp {
  pname = "sublime_syntax_convertor";
  gemdir = ./.;
  exes = [ "sublime_syntax_convertor" ];

  meta = with lib; {
    description = "Converts tmLanguage to sublime-syntax";
    homepage = "https://github.com/aziz/SublimeSyntaxConvertor/";
    license = licenses.mit;
    maintainers = with maintainers; [ laalsaas ];
  };
}
