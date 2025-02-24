{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  perl,
  python3,
}:
stdenv.mkDerivation {
  pname = "misc-gitology";
  version = "0-unstable-2024-08-26";

  src = fetchFromGitHub {
    owner = "da-x";
    repo = "misc-gitology";
    rev = "8f6b200ed5f4d39f86026cf050f325d5f5713950";
    hash = "sha256-6LoMJUOyBpP1HvVXNahEQlN1JKC9KflcOH9QWIi4M6s=";
  };

  dontBuild = true;

  buildInputs = [
    python3
    # For `git-find-blob`:
    perl
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    find . \
      -type f \
      -executable \
      -maxdepth 1 \
      -exec install --target-directory=$out/bin/ {} +
    runHook postInstall
  '';

  meta = with lib; {
    description = "Assortment of scripts around Git";
    homepage = "https://github.com/da-x/misc-gitology";
    license = [ licenses.bsd2 ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
