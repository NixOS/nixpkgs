{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "emojify";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mrowa44";
    repo = "emojify";
    rev = version;
    hash = "sha256-6cV+S8wTqJxPGsxiJ3hP6/CYPMWdF3qnz4ddL+F/oJU=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 emojify $out/bin/emojify
    runHook postInstall
  '';

  meta = with lib; {
    description = "Emoji on the command line";
    homepage = "https://github.com/mrowa44/emojify";
    license = licenses.mit;
    maintainers = with maintainers; [ snowflake ];
    platforms = platforms.all;
    mainProgram = "emojify";
  };
}
