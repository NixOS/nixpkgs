{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highs";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FRiYtbl1kWEkHHEIIOpefC9UdusmJKl6UmP3dKRkAXA=";
  };

  strictDeps = true;

  outputs = [ "out" ];

  doInstallCheck = true;

  installCheckPhase = ''
    "$out/bin/highs" --version
  '';

  nativeBuildInputs = [
    clang
    cmake
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ERGO-Code/HiGHS";
    description = "Linear optimization software";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "highs";
    maintainers = with maintainers; [
      galabovaa
      silky
    ];
  };
})
