{ stdenv, python3, fetchFromGitHub, makeWrapper, buildEnv, aspellDicts
# Use `lib.collect lib.isDerivation aspellDicts;` to make all dictionaries
# available.
, enchantAspellDicts ? with aspellDicts; [ en en-computers en-science ]
}:

let
  version = "7.0.4";
  python = let
    packageOverrides = self: super: {
      markdown = super.markdown.overridePythonAttrs(old: {
        src =  super.fetchPypi {
          version = "3.0.1";
          pname = "Markdown";
          sha256 = "d02e0f9b04c500cde6637c11ad7c72671f359b87b9fe924b2383649d8841db7c";
        };
      });

      chardet = super.chardet.overridePythonAttrs(old: {
        src =  super.fetchPypi {
          version = "2.3.0";
          pname = "chardet";
          sha256 = "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa";
        };
      });
    };
    in python3.override { inherit packageOverrides; };
  pythonEnv = python.withPackages (ps: with ps; [
    pyqt5 docutils pyenchant Markups markdown pygments chardet
  ]);
in python.pkgs.buildPythonApplication {
  inherit version;
  pname = "retext";

  src = fetchFromGitHub {
    owner = "retext-project";
    repo = "retext";
    rev = version;
    sha256 = "1zcapywspc9v5zf5cxqkcy019np9n41gmryqixj66zsvd544c6si";
  };

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ pythonEnv ];

  postInstall = ''
    mv $out/bin/retext $out/bin/.retext
    makeWrapper "$out/bin/.retext" "$out/bin/retext" \
      --set ASPELL_CONF "dict-dir ${buildEnv {
        name = "aspell-all-dicts";
        paths = map (path: "${path}/lib/aspell") enchantAspellDicts;
      }}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/retext-project/retext/;
    description = "Simple but powerful editor for Markdown and reStructuredText";
    license = licenses.gpl3;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.unix;
  };
}
