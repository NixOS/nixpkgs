{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "cook-cli";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${version}";
    hash = "sha256-jaAgmqUuqldcBlrwqXsausXPP35RZqM1VasYyA0pPO8=";
  };

  cargoHash = "sha256-JVWa5vQcskXEgOqAxr2CKQDMjYakA1HqinDbKfRp/Wo=";

  nativeBuildInputs = [
    pkg-config
    openssl
  ];

  buildInputs = [
    openssl
  ];

  postPatch = ''
    rm -rf "ui/public"
    ln -s ${passthru.ui} "ui/public"
  '';

  OPENSSL_NO_VENDOR = 1;

  passthru.ui = buildNpmPackage {
    name = "ui";
    src = "${src}/ui";
    npmDepsHash = "sha256-zx8G6Raop1EZAVy1YCF5ag5aL9NutRxbPfTARmjP2SY=";
    makeCacheWritable = true;
    npmFlags = [ "--legacy-peer-deps" ];
    installPhase = ''
      runHook preInstall
      mv public/ $out
      runHook postInstall
    '';
  };

  meta = {
    changelog = "https://github.com/cooklang/cookcli/releases/tag/v${version}";
    description = "Suite of tools to create shopping lists and maintain recipes";
    homepage = "https://cooklang.org/";
    license = lib.licenses.mit;
    mainProgram = "cook";
    maintainers = [ lib.maintainers.emilioziniades ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
