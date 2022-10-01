{ pkgs
, lib
, python3
, makeWrapper
, notmuch
, w3m
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dodo";
  version = "unstable-2022-06-09";
  format = "pyproject";

  src = pkgs.fetchFromGitHub {
    repo = pname;
    owner = "akissinger";
    rev = "b377e05ab507c7bec427e3bac0c35b68bd67d9fc";
    sha256 = "sha256-GcOcCB93/q84zPdiY8CgZN9MQtG2BG0miGsasonmofs=";
  };

  nativeBuildInputs = with python3.pkgs; [ setuptools-scm makeWrapper ];

  propagatedBuildInputs = with python3.pkgs; [
    bleach
    pyqt5
    pyqt5_sip
    pyqtwebengine
  ];

  postInstall = ''
    wrapProgram $out/bin/dodo --prefix PATH ":" \
      ${lib.makeBinPath [ notmuch w3m ]}
  '';

  meta = with lib; {
    description = "A graphical, hackable email client based on notmuch";
    homepage = "https://github.com/akissinger/dodo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

