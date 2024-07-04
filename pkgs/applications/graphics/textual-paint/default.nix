{ lib
, python3
, fetchFromGitHub
, fetchPypi
, fetchpatch
}:

let
  python = python3.override {
    packageOverrides = _: super: {
      pillow = super.pillow.overridePythonAttrs rec {
        version = "9.5.0";
        format = "pyproject";

        src = fetchPypi {
          pname = "Pillow";
          inherit version;
          hash = "sha256-v1SEedM2cm16Ds6252fhefveN4M65CeUYCYxoHDWMPE=";
        };

        patches = [
          # fix type handling for include and lib directories
          (fetchpatch {
            url = "https://github.com/python-pillow/Pillow/commit/0ec0a89ead648793812e11739e2a5d70738c6be5.patch";
            hash = "sha256-m5R5fLflnbJXbRxFlTjT2X3nKdC05tippMoJUDsJmy0=";
          })
        ];
      };

      textual = super.textual.overridePythonAttrs rec {
        version = "0.27.0";

        src = fetchFromGitHub {
          owner = "Textualize";
          repo = "textual";
          rev = "v${version}";
          hash = "sha256-ag+sJFprYW3IpH+BiMR5eSRUFMBeVuOnF6GTTuXGBHw=";
        };
      };
    };
  };
in

python.pkgs.buildPythonApplication rec {
  pname = "textual-paint";
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "1j01";
    repo = "textual-paint";
    rev = "v${version}";
    hash = "sha256-ubBWK4aoa9+wyUED7CmWwjknWsWauR/mkurDgkKDiY8=";
  };

  nativeBuildInputs = [
    python.pkgs.setuptools
    python.pkgs.wheel
  ];

  propagatedBuildInputs = with python.pkgs; [
    pillow
    pyfiglet
    pyperclip
    rich
    stransi
    textual
  ];

  pythonImportsCheck = [ "textual_paint" ];

  meta = with lib; {
    description = "TUI image editor inspired by MS Paint";
    homepage = "https://github.com/1j01/textual-paint";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "textual-paint";
  };
}
