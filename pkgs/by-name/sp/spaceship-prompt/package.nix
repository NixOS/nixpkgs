{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "spaceship-prompt";
<<<<<<< HEAD
  version = "4.21.0";
=======
  version = "4.19.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "spaceship-prompt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-6riMk22gsLhy3LmWu9TbUCl59fli54+uLo5mWUkU9wc=";
=======
    sha256 = "sha256-zMazuPTwvbmtd6BIjD7oDJ3V4TGlUnxJT25Pe1TI3UY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    install -Dm644 LICENSE.md "$out/share/licenses/spaceship-prompt/LICENSE"
    install -Dm644 README.md "$out/share/doc/spaceship-prompt/README.md"
    find docs -type f -exec install -Dm644 {} "$out/share/doc/spaceship-prompt/{}" \;
    find lib -type f -exec install -Dm644 {} "$out/lib/spaceship-prompt/{}" \;
    find scripts -type f -exec install -Dm644 {} "$out/lib/spaceship-prompt/{}" \;
    find sections -type f -exec install -Dm644 {} "$out/lib/spaceship-prompt/{}" \;
    install -Dm644 spaceship.zsh "$out/lib/spaceship-prompt/spaceship.zsh"
    install -Dm644 async.zsh "$out/lib/spaceship-prompt/async.zsh"
    install -d "$out/share/zsh/themes/"
    ln -s "$out/lib/spaceship-prompt/spaceship.zsh" "$out/share/zsh/themes/spaceship.zsh-theme"
    install -d "$out/share/zsh/site-functions/"
    ln -s "$out/lib/spaceship-prompt/spaceship.zsh" "$out/share/zsh/site-functions/prompt_spaceship_setup"
  '';

  meta = {
    description = "Zsh prompt for Astronauts";
    homepage = "https://github.com/denysdovhan/spaceship-prompt/";
    changelog = "https://github.com/spaceship-prompt/spaceship-prompt/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nyanloutre
      moni
      kyleondy
    ];
  };
}
