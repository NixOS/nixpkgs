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
    rev = "daa07f8d1972a9c755ebe52c7a947cd6688ac968";
    hash = "sha256-4oqk7+WNsERTPvYOy6Fsvlhi5NresGjVLKtcjnDEc+4=";
  };

  patches = [ ./0001.patch ];

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
