{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, rustPlatform
, pkg-config
, openssl
, darwin
}:
rustPlatform.buildRustPackage rec {
  pname = "cook-cli";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "cooklang";
    repo = "cookcli";
    rev = "v${version}";
    hash = "sha256-3gLVsk6GCxOG24Md7E9fk28Vnc4kVDdwyZUD/GtSwFE=";
  };

  cargoHash = "sha256-6lnURuE1cgNAniHl5ozXo1W3cLYYje7er+ZhvZDKdVg=";

  nativeBuildInputs = [ pkg-config openssl ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  postPatch = ''
    rm -rf "ui/public"
    ln -s ${passthru.ui} "ui/public"
  '';

  OPENSSL_NO_VENDOR = 1;

  passthru.ui = buildNpmPackage {
    name = "ui";
    src = "${src}/ui";
    npmDepsHash = "sha256-uMyOAYLVHhY4ytvEFvVzdoQ7ExzQ4sH+ZtDrEacu5bk=";
    makeCacheWritable = true;
    npmFlags = [ "--legacy-peer-deps" ];
    installPhase = ''
      runHook preInstall
      mv public/ $out
      runHook postInstall
    '';
  };

  meta = with lib; {
    changelog = "https://github.com/cooklang/cookcli/releases/tag/v${version}";
    description = "Suite of tools to create shopping lists and maintain recipes";
    homepage = "https://cooklang.org/";
    license = [ licenses.mit ];
    mainProgram = "cook";
    maintainers = [ maintainers.emilioziniades ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
