{ lib, fetchFromGitHub, python310Packages, wmctrl, qt5, qtbase, mkDerivationWith
}:

{
  stable = throw
    "plover.stable was removed because it used Python 2. Use plover.dev instead."; # added 2022-06-05

  dev = with python310Packages;
    let
      plover_stroke = mkDerivationWith buildPythonPackage rec {
        pname = "plover_stroke";
        version = "1.1.0";

        pyproject = true;

        src = fetchFromGitHub {
          owner = "openstenoproject";
          repo = "plover_stroke";
          rev = version;
          sha256 = "sha256-A75OMzmEn0VmDAvmQCp6/7uptxzwWJTwsih3kWlYioA=";
        };

        propagatedBuildInputs = [ setuptools ];

        nativeCheckInputs = [ pytestCheckHook ];
        pythonImportsCheck = [ "plover_stroke" ];

        meta = with lib; {
          description = "Stroke handling helper library for Plover";
          license = licenses.gpl2Plus;
          homepage = "https://github.com/openstenoproject/plover_stroke";
          platforms = platforms.linux ++ platforms.windows;
          maintainers = with maintainers; [ FirelightFlagboy ];
        };
      };

      rtf_tokenize = mkDerivationWith buildPythonPackage rec {
        pname = "rtf_tokenize";
        version = "1.0.0";

        pyproject = true;

        src = fetchFromGitHub {
          owner = "openstenoproject";
          repo = "rtf_tokenize";
          rev = version;
          sha256 = "sha256-zwD2sRYTY1Kmm/Ag2hps9VRdUyQoi4zKtDPR+F52t9A=";
        };

        propagatedBuildInputs = [ setuptools ];

        nativeCheckInputs = [ pytestCheckHook ];
        pythonImportsCheck = [ "rtf_tokenize" ];

        meta = with lib; {
          description = "Simple RTF tokenizer";
          license = licenses.gpl2Plus;
          homepage = "https://github.com/openstenoproject/rtf_tokenize";
          platforms = platforms.linux ++ platforms.windows;
          maintainers = with maintainers; [ FirelightFlagboy ];
        };
      };
    in mkDerivationWith buildPythonPackage rec {
      pname = "plover";
      version = "4.0.0rc2";

      pyproject = true;

      src = fetchFromGitHub {
        owner = "openstenoproject";
        repo = "plover";
        rev = "v${version}";
        sha256 = "sha256-rmMec/BbvOJ92u8Tmp3Kv2YezzJxB/L8UrDntTDSKj4=";
      };

      propagatedBuildInputs = [
        babel
        pyqt5
        xlib
        pyserial
        appdirs
        wcwidth
        setuptools
        plover_stroke
        rtf_tokenize
      ];

      buildInputs = [ qt5.qtwayland ];

      nativeCheckInputs = [ pytestCheckHook mock ];

      dontWrapQtApps = true;

      preFixup = ''
        makeWrapperArgs+=("''${qtWrapperArgs[@]}")
      '';

      meta = with lib; {
        mainProgram = "plover";
        broken = stdenv.isDarwin;
        description = "OpenSteno Plover stenography software";
        maintainers = with maintainers; [ FirelightFlagboy twey kovirobi ];
        license = licenses.gpl2;
      };
    };
}
