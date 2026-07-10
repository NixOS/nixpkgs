{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
}:

let
  ## https://github.com/deep5050/radio-active/blob/main/requirements.txt
  pyradios_1-0-2 = python3Packages.pyradios.overrideAttrs (
    finalAttrs: previousAttrs:
    let
      version = "1.0.2";
    in
    {
      inherit version;

      src = previousAttrs.src.override {
        inherit version;
        hash = "sha256-O30ExmvWu4spwDytFVPWGjR8w3XSTaWd2Z0LGQibq9g=";
      };
    }
  );

  pname = "radio-active";
  version = "2.9.1";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "S0AndS0";
    repo = "radio-active";
    rev = "2befa6a309d9c411ef1ea522e706ed3e098e5341";
    hash = "sha256-wqETmdqvxsKnjkjQADq59J83QkOhLA74SPtuWTpsvO0=";
  };

  postPatch = ''
    substituteInPlace radioactive/recorder.py \
      --replace-fail '"ffmpeg",' '"${lib.getExe ffmpeg}",'

    substituteInPlace radioactive/ffplay.py \
      --replace-fail 'self.exe_path = which(self.program_name)' \
      'self.exe_path = "${ffmpeg.outPath}/bin/ffplay"'
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    requests
    urllib3
    psutil
    pyradios_1-0-2
    zenlog
    requests-cache
    rich
    pick
  ];

  meta = {
    description = "Play any radios from around the globe right from the terminal";
    homepage = "https://www.radio-browser.info/";
    changelog = "https://github.com/deep5050/radio-active/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ S0AndS0 ];
  };
}
