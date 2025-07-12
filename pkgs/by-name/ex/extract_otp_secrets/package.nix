{
  lib,
  copyDesktopItems,
  fetchFromGitHub,
  makeDesktopItem,
  python3Packages,
}:

let
  pyPkgs = python3Packages.overrideScope (
    self: super: {
      opencv4 = super.opencv4.override {
        enableGtk3 = true;
      };
    }
  );
in
pyPkgs.buildPythonApplication rec {
  pname = "extract_otp_secrets";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scito";
    repo = "extract_otp_secrets";
    tag = "v${version}";
    hash = "sha256-deN+UOPE8S13QdUdxEdv1jx7ZAgUnrXp9jObWpo0NEw=";
  };

  build-system = with pyPkgs; [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = with pyPkgs; [
    colorama
    opencv4
    pillow
    protobuf
    pyzbar
    qrcode
    qreader_1
  ];

  prePatch = ''
    # pythonRuntimeDepsCheck does not recognize that opencv-contrib-python is installed
    # even though opencv is built with contrib (by default)
    substituteInPlace pyproject.toml requirements.txt \
      --replace-warn opencv-contrib-python opencv-python
  '';

  patches = [
    # Remove the build-time dependencies on Nuitka and Pip. They are not used when installing
    # the package as we do but only for building the single-file executables.
    ./dependencies.diff
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  nativeCheckInputs = with pyPkgs; [
    pytestCheckHook
    pytest-mock
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = pname;
      name = pname;
      genericName = "Extract OTP secrets from QR codes";
      exec = meta.mainProgram;
      categories = [
        "Utility"
      ];
    })
  ];

  meta = {
    description = "Extracts OTP secrets from QR codes exported by 2FA apps";
    longDescription = ''
      Extracts one time password (OTP) secrets from QR codes exported by
      two-factor authentication (2FA) apps such as "Google Authenticator". The
      exported QR codes from authentication apps can be captured by camera,
      read from images, or read from text files. The secrets can be exported to
      JSON or CSV, or printed as QR codes to console.
    '';
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/scito/extract_otp_secrets";
    maintainers = with lib.maintainers; [ nova ];
    mainProgram = pname;
  };
}
