{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "diskus";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.8.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-z0w2wzlbF7mY8kr6N//Rsm8G5P1jhrEwoOJ7MYrbKIE=";
  };

  cargoHash = "sha256-PngglR3BNktjnb8hdd3A6iKu/Q0OCCj9aTxyWBuy6a0=";

  meta = {
    description = "Minimal, fast alternative to 'du -sh'";
    homepage = "https://github.com/sharkdp/diskus";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ lib.maintainers.fuerbringer ];
    platforms = lib.platforms.unix;
=======
    sha256 = "sha256-88+U5Y2CC0PhikRO3VqoUwZEYZjwln+61OPWbLLb8T0=";
  };

  cargoHash = "sha256-keBnhE4ltOVMEuxPifiB2EAHk32u3PqaPGTeVexVXWM=";

  meta = with lib; {
    description = "Minimal, fast alternative to 'du -sh'";
    homepage = "https://github.com/sharkdp/diskus";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ maintainers.fuerbringer ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    longDescription = ''
      diskus is a very simple program that computes the total size of the
      current directory. It is a parallelized version of du -sh.
    '';
    mainProgram = "diskus";
  };
}
