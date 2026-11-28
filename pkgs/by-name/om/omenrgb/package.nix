{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
  wxGTK32,
  coreutils,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "omenrgb";
  version = "master";

  src = fetchFromGitHub {
    owner = "lemogne";
    repo = "omenrgb";
    rev = "5b68bc0a299df8926a03cded868766cc95ba644f";
    hash = "sha256-lIr0Er4kt4UKeqg8smroBZ7ToOywP8C80+eIgGs3tWg=";
  };

  postPatch = ''
    substituteInPlace ./backlight.rules \
      --replace-fail '/bin/chmod' '${coreutils}/bin/chmod'
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    gcc
    wxGTK32
  ];

  buildPhase = ''
    runHook preBuild
    bash ./build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp omenrgb $out/bin/omenrgb
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp backlight.rules $out/etc/udev/rules.d/81-backlight.rules
  '';

  meta = {
    description = "GUI for controlling RGB lighting on OMEN laptops for Linux";
    homepage = "https://github.com/lemogne/omenrgb";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ern775 ];
    mainProgram = "omenrgb";
    platforms = lib.platforms.all;
  };
}
