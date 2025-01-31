{
  coreutils,
  fetchFromGitHub,
  gh,
  lib,
  makeWrapper,
  nix-update-script,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "gh-contribs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "MintArchit";
    repo = "gh-contribs";
    rev = "v${version}";
    hash = "sha256-yPJ9pmnbqR+fXH02Q5VMn0v2MuDQbPUpNzKw1awmKVE=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -D -m755 "gh-contribs" "$out/bin/gh-contribs"
  '';

  postFixup = ''
    wrapProgram "$out/bin/gh-contribs" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gh
        ]
      }"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/MintArchit/gh-contribs";
    description = "GitHub Contribution Graph CLI";
    maintainers = [ lib.maintainers.vinnymeller ];
    license = lib.licenses.unlicense;
    mainProgram = "gh-contribs";
    platforms = lib.platforms.all;
  };
}
