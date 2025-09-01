{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  makeBinaryWrapper,
  gh,
  fzf,
  coreutils,
  gawk,
  gnused,
  withBat ? false,
  bat,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gh-f";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "gh-f";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rMGyiXniW3M4JnsWufXcsU8mL8KlrIRGGgbQT6utnuc=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  propagatedUserEnvPkgs = [
    gh
    fzf
    coreutils
    gawk
    gnused
  ]
  ++ lib.optional withBat bat;

  installPhase = ''
    runHook preInstall

    install -D -m755 "gh-f" "$out/bin/gh-f"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/gh-f" \
      --suffix PATH : ${lib.makeBinPath finalAttrs.propagatedUserEnvPkgs}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/gennaro-tedesco/gh-f";
    description = "GitHub CLI ultimate FZF extension";
    license = lib.licenses.unlicense;
    mainProgram = "gh-f";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      loicreynier
      yiyu
    ];
  };
})
