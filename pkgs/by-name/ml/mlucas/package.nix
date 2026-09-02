{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  versionCheckHook,
}:
let

  platform = if stdenv.hostPlatform.system == "aarch64-linux" then "asimd" else "avx2";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "mlucas";
  version = "21.0.2";

  src = fetchFromGitHub {
    owner = "primesearch";
    repo = "Mlucas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AHzx7jfmBIzES9fJ9xhmRMD8NCucxhD2aEo8OYR25xs=";
  };

  enableParallelBuilding = true;

  buildInputs = [
    gmp
  ];

  postPatch = ''
    chmod +x makemake.sh
    patchShebangs makemake.sh
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  buildPhase = ''
    runHook preBuild

    ./makemake.sh ${platform}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 obj_${platform}/Mlucas $out/bin/mlucas

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Open-source program for primality testing of Mersenne numbers";
    longDescription = ''
      This program may be used to test any suitable number as you wish, but it is preferable that you do so in a coordinated fashion,
      as part of the Great Internet Mersenne Prime Search (GIMPS). Note that on x86 processors Mlucas is not as efficient
      as the main GIMPS client, George Woltman's Prime95 program (a.k.a. mprime for the linux version),
      but that program is not 100% open-source. Prime95 is also only available for platforms based on the
      x86 processor architecture. The help.txt file in the Github repo includes a variety of usage information
      not covered in the original README.
    '';
    homepage = "https://github.com/primesearch/Mlucas";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "mlucas";
  };
})
