{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  perl,
  python3,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "easel";
  version = "0.49";

  src = fetchFromGitHub {
    owner = "EddyRivasLab";
    repo = "easel";
    tag = "easel-${finalAttrs.version}";
    hash = "sha256-NSKy7ptNYR0K/VFJNv+5TGWdC1ZM4Y5i/3L+3Coj/sg=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeCheckInputs = [
    perl
    python3
  ];

  preCheck = ''
    patchShebangs devkit/sqc
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = with lib; {
    description = "Sequence analysis library used by Eddy/Rivas lab code";
    homepage = "https://github.com/EddyRivasLab/easel";
    license = licenses.bsd2;
    mainProgram = "easel";
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
