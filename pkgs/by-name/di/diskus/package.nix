{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diskus";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "diskus";
    rev = "v${finalAttrs.version}";
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
    longDescription = ''
      diskus is a very simple program that computes the total size of the
      current directory. It is a parallelized version of du -sh.
    '';
    mainProgram = "diskus";
  };
})
