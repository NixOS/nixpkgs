{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fsmon";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "nowsecure";
    repo = "fsmon";
    tag = version;
    hash = "sha256-WxOPNc939qwrdDNC3v3pmcltd8MnM8Gsu8t6VR/ZWYY=";
  };

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
    description = "FileSystem Monitor utility";
    homepage = "https://github.com/nowsecure/fsmon";
    changelog = "https://github.com/nowsecure/fsmon/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux;
    mainProgram = "fsmon";
  };
}
