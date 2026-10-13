{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  cowsay,
  coreutils,
  findutils,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pokemonsay";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "HRKings";
    repo = "pokemonsay-newgenerations";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MHR9rr/dIQF0POLHAXgd2JaIPu+QqwFbDpwSWbSsWQA=";
  };

  postPatch = ''
    substituteInPlace pokemonsay.sh \
      --replace-fail \
        'INSTALL_PATH=''${HOME}/.bin/pokemonsay' \
        "" \
      --replace-fail \
        'POKEMON_PATH=''${INSTALL_PATH}/pokemons' \
        'POKEMON_PATH=${placeholder "out"}/share/pokemonsay' \
      --replace-fail \
        '$(find ' \
        '$(${findutils}/bin/find ' \
      --replace-fail \
        '$(basename ' \
        '$(${coreutils}/bin/basename ' \
      --replace-fail \
        'cowsay -f ' \
        '${cowsay}/bin/cowsay -f ' \
      --replace-fail \
        'cowthink -f ' \
        '${cowsay}/bin/cowthink -f '

    substituteInPlace pokemonthink.sh \
      --replace-fail \
        './pokemonsay.sh' \
        "${placeholder "out"}/bin/pokemonsay"
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/pokemonsay}
    cp pokemonsay.sh $out/bin/pokemonsay
    cp pokemonthink.sh $out/bin/pokemonthink
    cp pokemons/*.cow $out/share/pokemonsay
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    (set -x
      test "$($out/bin/pokemonsay --list | wc -l)" -ge 992
    )
  '';

  meta = {
    description = "Print pokemon in the CLI! An adaptation of the classic cowsay";
    changelog = "https://github.com/HRKings/pokemonsay-newgenerations/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/HRKings/pokemonsay-newgenerations";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "pokemonsay";
  };
})
