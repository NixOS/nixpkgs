{
  rustPlatform,
  callPackage,
  pkg-config,
  lib,
  fetchFromGitHub,
  libayatana-appindicator,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "gg-jj";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "gulbanana";
    repo = "gg";
    rev = "refs/tags/v${version}";
    hash = "sha256-xOi/AUlH0FeenTXz3hsDYixCEl+yr22PGy6Ow4TKxY0=";
  };

  sourceRoot = "${src.name}/src-tauri";

  webui = callPackage ./webui.nix {
    inherit
      src
      pname
      version
      meta
      ;
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  buildInputs = [
    webkitgtk_4_1
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  cargoHash = "sha256-u3SkRA7327ZwqEnB+Xq2JDbI0k5HfeKzV17dvQ8B6xk=";

  postPatch = ''
    buildRoot=$(pwd)
    pushd $cargoDepsCopy/libappindicator-sys
    oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    substituteInPlace .cargo-checksum.json \
      --replace-fail $oldHash $(sha256sum src/lib.rs | cut -d " " -f 1)
    popd

    pushd $cargoDepsCopy/jj-cli
    oldHash=$(sha256sum build.rs | cut -d " " -f 1)
    substituteInPlace build.rs \
      --replace-fail 'let path = std::env::var("CARGO_MANIFEST_DIR").unwrap();' "let path = \"$buildRoot\";"
    substituteInPlace .cargo-checksum.json \
      --replace-fail $oldHash $(sha256sum build.rs | cut -d " " -f 1)
    popd

    substituteInPlace ./tauri.conf.json \
      --replace-fail '"frontendDist": "../dist"' '"frontendDist": "${webui}"' \
      --replace-fail '"beforeBuildCommand": "npm run build"' '"beforeBuildCommand": ""'
  '';

  meta = {
    homepage = "https://github.com/gulbanana/gg";
    changelog = "https://github.com/gulbanana/gg/releases/tag/v${version}";
    description = "GUI for jj users";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "gg";
    license = lib.licenses.apsl20;
  };
}
