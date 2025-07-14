{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "meslo-lgs-nf";
  version = "unstable-2023-04-03";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k-media";
    rev = "145eb9fbc2f42ee408dacd9b22d8e6e0e553f83d";
    sha256 = "sha256-8xwVOlOP1SresbReNh1ce2Eu12KdIwdJSg6LKM+k2ng=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src/*.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Meslo Nerd Font patched for Powerlevel10k";
    homepage = "https://github.com/romkatv/powerlevel10k-media";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
