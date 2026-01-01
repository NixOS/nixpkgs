{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "nullidentdmod";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Ranthrall";
    repo = "nullidentdmod";
    rev = "v${version}";
    sha256 = "1ahwm5pyidc6m07rh5ls2lc25kafrj233nnbcybprgl7bqdq1b0k";
  };

  installPhase = ''
    mkdir -p $out/bin

    install -Dm755 nullidentdmod $out/bin
  '';

<<<<<<< HEAD
  meta = {
    description = "Simple identd that just replies with a random string or customized userid";
    mainProgram = "nullidentdmod";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/Ranthrall/nullidentdmod";
    maintainers = with lib.maintainers; [ das_j ];
    platforms = lib.platforms.linux; # Must be run by systemd
=======
  meta = with lib; {
    description = "Simple identd that just replies with a random string or customized userid";
    mainProgram = "nullidentdmod";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/Ranthrall/nullidentdmod";
    maintainers = with maintainers; [ das_j ];
    platforms = platforms.linux; # Must be run by systemd
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
