{ lib
, buildNpmPackage
, fetchFromGitHub
, nodejs
, bash
, nix-update-script
}:

buildNpmPackage rec {
  pname = "lx-music-sync-server";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "lyswhut";
    repo = "lx-music-sync-server";
    rev = "v${version}";
    hash = "sha256-FRk7bY2ijlCgzbtN6yRHP2pFQYQsAYj7RxpHVU0IYQo=";
  };

  npmDepsHash = "sha256-04OYD/H/vnlQBgG9o6FZfPc0xHE1MLURlGeqtbvLTZc=";
  makeCacheWritable = true;

  buildInputs = [
    nodejs
    bash
  ];

  postInstall = ''
    cp -r server $out/lib/node_modules/lx-music-sync-server
    install -Dm0555 ${./wrapper.sh} $out/bin/lx-music-sync-server

    substituteInPlace $out/bin/lx-music-sync-server \
        --replace-fail "@@node@@" "${nodejs}/bin/node" \
        --replace-fail "@@out@@" "$out"
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Data synchronization service of LX Music running on Node.js";
    homepage = "https://github.com/lyswhut/lx-music-sync-server";
    changelog = "https://github.com/lyswhut/lx-music-sync-server/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "lx-music-sync-server";
    maintainers = with lib.maintainers; [ oo-infty ];
  };
}
