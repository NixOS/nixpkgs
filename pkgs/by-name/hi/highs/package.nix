{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highs";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "ERGO-Code";
    repo = "HiGHS";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-q18TfKbZyTZzzPZ8z3U57Yt8q2PSvbkg3qqqiPMgy5Q=";
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
    maintainers = with maintainers; [ silky ];
  };
})
