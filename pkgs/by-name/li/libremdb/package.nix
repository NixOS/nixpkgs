{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libremdb";
  version = "4.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zyachel";
    repo = "libremdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u2ooKAlTuttxI+8qxvTlTRojy0gO7lNk7kPn35DOifU=";
  };

  patches = [
    ./add-packages-field.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    pname = "libremdb";
    inherit (finalAttrs) version;
    src = stdenv.mkDerivation {
      name = "libremdb-patched-src";
      inherit (finalAttrs) src patches;
      installPhase = "cp -r . $out";
    };
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-QziWs5EWoKHtwj0KQvdoH1YyfCHa6SjYErCYPl0uBcc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
    makeWrapper
  ];

  postBuild = ''
    pnpm build
  '';

  postInstall = ''
    mkdir -p $out/share/libremdb
    cp -r .next public package.json node_modules $out/share/libremdb/

    makeWrapper ${nodejs}/bin/node $out/bin/libremdb \
      --add-flags "$out/share/libremdb/node_modules/next/dist/bin/next" \
      --add-flags "start" \
      --add-flags "$out/share/libremdb"
  '';

  meta = {
    description = "Free and open source IMDb frontend";
    longDescription = ''
      Privacy-respecting alternative frontend for IMDb, allowing users to browse
      movie and television information without ads or tracking.
    '';
    homepage = "https://libremdb.iket.me";
    changelog = "https://github.com/zyachel/libremdb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "libremdb";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "armv7l-linux"
      "s390x-linux"
      "x86_64-linux"
    ];
  };
})
