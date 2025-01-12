{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "arubaotp-seed-extractor";
  version = "unstable-22-12-2022";

  src = fetchFromGitHub {
    owner = "andry08";
    repo = "ArubaOTP-seed-extractor";
    rev = "534f78bb71594d5806fd2d7a8eade109b0e1d402";
    hash = "sha256-1pv88OClskQOPtJaP7g0duXMe/X3M6Tk+ituZ9UxoIE=";
  };

  format = "other";

  nativeBuildInputs = [
    python3Packages.wrapPython
  ];

  pythonPath = with python3Packages; [
    pycryptodome
    pyotp
    qrcode
    requests
  ];

  installPhase = ''
    libdir="$out/${python3Packages.python.sitePackages}/arubaotp-seed-extractor"
    mkdir -p "$libdir"
    cp scripts/* "$libdir"
    chmod +x "$libdir/main.py"
    wrapPythonProgramsIn "$libdir" "$pythonPath"
    mkdir -p $out/bin
    ln -s "$libdir/main.py" $out/bin/arubaotp-seed-extractor
  '';

  meta = with lib; {
    homepage = "https://github.com/andry08/ArubaOTP-seed-extractor";
    description = "Extract TOTP seed instead of using ArubaOTP app";
    mainProgram = "arubaotp-seed-extractor";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
