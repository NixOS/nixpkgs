{
  hostname,
  fetchFromGitHub,
  lib,
  makeWrapper,
  netcat-gnu,
  nix-update-script,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "piu-piu";
  version = "1.2";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "vaniacer";
    repo = "piu-piu-SH";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lwInRjaASHejyqwXuZLuKGj/vEbipgdHgVhQLX09nsc=";
  };

  passthru.updateScript = nix-update-script { };

  # netcata and hostname are used for the multiplayer
  installPhase = ''
    install -m755 -D piu-piu "$out/bin/piu-piu"
    wrapProgram "$out/bin/piu-piu" --prefix PATH : "${
      lib.makeBinPath [
        hostname
        netcat-gnu
      ]
    }"
  '';

  meta = {
    description = "Old School horizontal scroller 'Shoot Them All' game in bash";
    homepage = "https://github.com/vaniacer/piu-piu-SH";
    changelog = "https://github.com/vaniacer/piu-piu-SH/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "piu-piu";
    platforms = lib.platforms.all;
  };
})
