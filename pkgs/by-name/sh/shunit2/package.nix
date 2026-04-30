{
  coreutils,
  fetchFromGitHub,
  findutils,
  gnugrep,
  gnused,
  lib,
  makeWrapper,
  ncurses,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shunit2";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "kward";
    repo = "shunit2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IZHkgkVqzeh+eEKCDJ87sqNhSA+DU6kBCNDdQaUEeiM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace shunit2 \
      --replace-fail '/usr/bin/od' '${coreutils}/bin/od'
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 shunit2 $out/bin/shunit2

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/shunit2 \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gnused
          ncurses
        ]
      }
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/shunit2
  '';

  meta = {
    homepage = "https://github.com/kward/shunit2";
    description = "XUnit based unit test framework for Bourne based shell scripts";
    maintainers = with lib.maintainers; [
      abathur
      utdemir
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "shunit2";
  };
})
