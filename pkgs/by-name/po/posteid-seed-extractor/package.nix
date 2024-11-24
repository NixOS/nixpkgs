{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication {
  pname = "posteid-seed-extractor";
  version = "unstable-2022-02-23";

  src = fetchFromGitHub {
    owner = "simone36050";
    repo = "PosteID-seed-extractor";
    rev = "667e2997a98aa3273a6bf6b4b34ca77715120e7f";
    hash = "sha256-smNwp67HYbZuMrl0uf2X2yox2JqeEV6WzIBp4dALwgw=";
  };

  format = "other";

  pythonPath = with python3Packages; [
   certifi
   cffi
   charset-normalizer
   cryptography
   idna
   jwcrypto
   pycparser
   pycryptodome
   pyotp
   qrcode
   requests
   urllib3
   wrapt
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 extractor.py $out/bin/posteid-seed-extractor
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/simone36050/PosteID-seed-extractor";
    description = "Extract OTP seed instead of using PosteID app";
    mainProgram = "posteid-seed-extractor";
    license = licenses.mit;
    maintainers = with maintainers; [ aciceri ];
  };
}
