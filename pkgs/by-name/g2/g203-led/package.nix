{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:
stdenv.mkDerivation {
  pname = "g203-led";
  version = "0-unstable-2021-05-08";
  src = fetchFromGitHub {
    owner = "smasty";
    repo = "g203-led";
    rev = "f9d10ba3aa8f9359f928bbab0a2ea00cefc69f4b";
    sha256 = "1fhaimci80xmihg84bgrml61zr56pi9rkxfbs13vvw9dwjf031k0";
  };

  buildInputs = [
    (python3.withPackages (
      ps: with ps; [
        pyusb
      ]
    ))
  ];

  postPatch = ''
    patchShebangs g203-led.py
  '';

  installPhase = ''
    runHook preInstall
    install -D g203-led.py $out/bin/g203-led
    runHook postInstall
  '';

  meta = with lib; {
    description = "Logitech G203 Prodigy / G203 LightSync Mouse LED control for Linux";
    longDescription = ''
      Allows you to control the LED lighting of your G203 Prodigy
      or G203 LightSync Mouse programmatically.
      Inspired by and based on g810-led.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ r-burns ];
    homepage = "https://github.com/smasty/g203-led";
    platforms = platforms.linux;
    mainProgram = "g203-led";
  };
}
