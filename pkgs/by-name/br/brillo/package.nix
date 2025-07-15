{
  lib,
  stdenv,
  fetchFromGitLab,
  go-md2man,
  coreutils,
  replaceVars,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "brillo";
  version = "1.4.13";

  src = fetchFromGitLab {
    owner = "cameronnemo";
    repo = "brillo";
    rev = "v${version}";
    hash = "sha256-+BUyM3FFnsk87NFaD9FBwdLqf6wsNhX+FDB7nqhgAmM=";
  };

  patches = [
    (replaceVars ./udev-rule.patch {
      inherit coreutils;
      # patch context
      group = null;
    })
  ];

  nativeBuildInputs = [
    go-md2man
    udevCheckHook
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "AADIR=$(out)/etc/apparmor.d"
  ];

  doInstallCheck = true;

  installTargets = [ "install-dist" ];

  meta = with lib; {
    description = "Backlight and Keyboard LED control tool";
    homepage = "https://gitlab.com/cameronnemo/brillo";
    mainProgram = "brillo";
    license = [
      licenses.gpl3Only
      licenses.bsd0
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.alexarice ];
  };
}
