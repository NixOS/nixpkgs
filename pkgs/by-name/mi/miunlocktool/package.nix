{
  lib,
  fetchFromGitHub,
  python3Packages,
  android-tools,
}:

python3Packages.buildPythonApplication rec {
  pname = "miunlocktool";
  version = "1.5.9-unstable-2025-05-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "offici5l";
    repo = "MiUnlockTool";
    rev = "3f4581341bc380e66b14ebd80f596ea6fd34a32c";
    hash = "sha256-uXYWYzn5zwzX6yXQjQWV95t9YmEnZqxPRPYoy8M+7Fk=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];
  dependencies =
    [ android-tools ]
    ++ (with python3Packages; [
      requests
      colorama
      pycryptodomex
    ]);

  installPhase = ''
    install -Dm0755 MiUnlockTool.py $out/bin/miunlocktool
    patchShebangs $out/bin/miunlocktool

    wrapProgram $out/bin/miunlocktool \
      --prefix PATH : ${lib.makeBinPath [ android-tools ]}
  '';

  meta = {
    description = "Mi Account Unlock Tool";
    homepage = "https://github.com/offici5l/MiUnlockTool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ phodina ];
    platforms = lib.platforms.all;
  };
}
