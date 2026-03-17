{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "jwtcat";
  version = "0-unstable-2022-10-15";
  format = "other";
  doCheck = false;

  src = fetchFromGitHub {
    owner = "aress31";
    repo = "jwtcat";
    rev = "f80f3d9352b82f0e7da504b2ee11f4a61f23c385";
    hash = "sha256-pk0/Lzw4yUIXfLBX/0Xwaecio42MjLYUzECQ8xaH3vY=";
  };

  dependencies = with python3Packages; [
    pyjwt
    coloredlogs
    tqdm
  ];

  installPhase = ''
    install -Dm755 jwtcat.py $out/bin/jwtcat
  '';

  meta = {
    description = "A CPU-based JSON Web Token (JWT) cracker and - to some extent - scanner.";
    homepage = "https://github.com/aress31/jwtcat";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _0x2B ];
    mainProgram = "jwtcat";
  };
}
