{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "dmitry";
  version = "1.3a-unstable-2020-06-22";

  src = fetchFromGitHub {
    owner = "jaygreig86";
    repo = "dmitry";
    rev = "f3ae08d4242e3e178271c827b86ff0d655972280";
    hash = "sha256-cYFeBM8xFMaLXYk6Rg+5JvfbbIJI9F3mefzCX3+XbB0=";
  };

  patches = [
    (fetchpatch {
      name = "implicit-function-declaration.patch";
      url = "https://github.com/jaygreig86/dmitry/pull/14/commits/8385e1f915ba38938bca0453ed3302fa660aec07.patch";
      hash = "sha256-jkb6tFATGClFIShfEdQG95hn5+xlrhJ6JiGDwooEB4I=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fcommon" ];

  meta = {
    description = "Deepmagic Information Gathering Tool";
    mainProgram = "dmitry";
    homepage = "https://github.com/jaygreig86/dmitry";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
