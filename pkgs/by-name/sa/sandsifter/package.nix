{
  lib,
  fetchFromGitHub,
  stdenv,
  capstone,
  python312,
}:

let
  pythonEnv = python312.withPackages (ps: with ps; [ ps.capstone ]);
in

stdenv.mkDerivation {
  pname = "sandsifter";
  version = "1.0.0-unstable-2024-12-13";

  src = fetchFromGitHub {
    owner = "jakiki6";
    repo = "sandsifter";
    rev = "2dcaf26282a1fa451006d6aaebb9a657a5bce8e8";
    hash = "sha256-7cREZMXR4m7F2u+6ADwjP4GEADu6oYQISgHl/N5UtMs=";
  };

  nativeBuildInputs = [
    capstone
    pythonEnv
  ];

  env.NIX_HARDENING_ENABLE = "format stackprotector strictoverflow";

  buildPhase = ''
    runHook preBuild
    gcc -Wall -O0 -no-pie -pthread -o injector injector.c -lcapstone
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp injector $out/bin/
    cp sifter.py summarize.py $out/bin/
    for script in sifter.py summarize.py; do
      substituteInPlace $out/bin/$script \
        --replace-fail "#!/usr/bin/python3" "#!${pythonEnv}/bin/python3"
      chmod +x $out/bin/$script
    done
    substituteInPlace $out/bin/sifter.py \
      --replace-fail 'INJECTOR = "./injector"' "INJECTOR = \"$out/bin/injector\""
    runHook postInstall
  '';

  meta = {
    description = "x86 processor fuzzer";
    homepage = "https://github.com/jakiki6/sandsifter";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "sifter.py";
  };
}
