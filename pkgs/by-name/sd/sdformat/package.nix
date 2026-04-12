{
  lib,
  stdenv,
  fetchFromGitHub,
  util-linuxMinimal,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdformat";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "profi200";
    repo = "sdFormatLinux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AoAhP1dr+hQSnOpZC0oHt0j3fUVNVhD+3jWm6iMfskk=";
  };

  nativeBuildInputs = [ installShellFiles ];

  patches = [ ./remove-hardcoded-lsblk-path.diff ];

  strictDeps = true;

  makeFlags = [
    "TARGET=${finalAttrs.pname}"
    "LSBLK_PATH=${lib.getExe' util-linuxMinimal "lsblk"}"
  ];

  installPhase = ''
    runHook preInstall

    installBin ${finalAttrs.pname}

    runHook postInstall
  '';

  meta = {
    description = "Format your SD card the way the SD Association intended";
    homepage = "https://github.com/profi200/sdFormatLinux";
    license = lib.licenses.mit;
    mainProgram = finalAttrs.pname;
    maintainers = with lib.maintainers; [ thiagokokada ];
    platforms = lib.platforms.linux;
  };
})
