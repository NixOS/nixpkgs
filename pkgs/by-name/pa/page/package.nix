{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "page";
  version = "4.6.3";

  src = fetchFromGitHub {
    owner = "I60R";
    repo = "page";
    rev = "v${version}";
    hash = "sha256-uNdtgx9/9+KOfQvHiKNrT8NFWtR2tfJuI2bMwywBC/4=";
  };

  cargoHash = "sha256-ZoLYnXU1y+7AcbxUlcY9MPGZuuxzG8d5Im2/uSlCoaw=";

  cargoPatches = [
    # Cargo.lock is outdated.
    # https://github.com/I60R/page/pull/45.
    (fetchpatch {
      url = "https://github.com/I60R/page/commit/83f936b64620ba74043c1db31207b4366c0f7e3d.patch";
      hash = "sha256-qA5oP4K/6eG0A+syVNb1izl+bnYll5V6sWM3LVFTb4o=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    completions_dir=$(find "target" -name "assets" -type d -printf "%T+\t%p\n" | sort | awk 'NR==1{print $2}')
    installShellCompletion --bash $completions_dir/page.bash
    installShellCompletion --fish $completions_dir/page.fish
    installShellCompletion --zsh $completions_dir/_page
  '';

  meta = with lib; {
    description = "Use neovim as pager";
    homepage = "https://github.com/I60R/page";
    license = licenses.mit;
    mainProgram = "page";
    maintainers = [ maintainers.s1341 ];
  };
}
