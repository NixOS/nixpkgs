{
  lib,
  python312Packages,
  fetchFromGitHub,
  xclip,
  xsel,
}:

python312Packages.buildPythonApplication rec {
  pname = "sideband";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Sideband";
    tag = "${version}";
    hash = "sha256-whrmeIcS4+KkDR0j2Cp1F2EkimSl4djSRrPHVQwiK2A=";
  };

  patches = [ ./fix-kv-packaging.patch ]; # https://github.com/markqvist/Sideband/pull/72

  build-system = with python312Packages; [
    setuptools
  ];

  dependencies = with python312Packages; [
    pyaudio
    pycodec2
    audioop-lts
    mistune
    beautifulsoup4
    sh
    materialyoucolor
    qrcode
    pillow
    kivy
    lxmf
    rns
    numpy_1
    ffpyplayer
    lxst
  ];

  propagatedBuildInputs = [
    xclip
    xsel
  ];

  meta = {
    description = "Extensible Reticulum LXMF messaging and LXST telephony client";
    homepage = "https://github.com/markqvist/Sideband";
    license = lib.licenses.cc-by-nc-sa-40;
    mainProgram = "sideband";
  };
}
