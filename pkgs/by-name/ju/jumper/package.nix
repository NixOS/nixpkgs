{
  stdenv,
  fetchFromGitHub,
  which,
  fzf,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "jumper";
  version = "0-unstable-2024-08-26";
  src = fetchFromGitHub {
    owner = "homerours";
    repo = "jumper";
    rev = "264f291754a99ea4aa44d05e6a1a0f4b9159fc8c";
    hash = "sha256-6++r0mBrV+KhQc7WRiKd8l52CKJUcvzPFqe4S6O6J84=";
  };

  nativeBuildInputs = [
    which # removes comp warning
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 jumper -T $out/bin/jumper

    runHook postInstall
  '';

  meta = {
    mainProgram = "jumper";
    description = "Jump into directories and files that you frequently visit";
    homepage = "https://github.com/homerours/jumper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ camerondugan ];
    platforms = lib.platforms.unix;
  };
})
