{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  fetchFromGitHub,
  dpkg,
  glib,
  gnutar,
  gtk3-x11,
  luajit,
  sdcv,
  SDL2,
  openssl,
  writeScript,
}:
let
  luajit_lua52 = luajit.override { enable52Compat = true; };

  version = "2025.08";

  src_repo = fetchFromGitHub {
    repo = "koreader";
    owner = "koreader";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-lkXpmvde1PPJRocnRpmuu4AeCv/0Mql40Aw5WIZfj5s=";
  };
in
stdenv.mkDerivation {
  pname = "koreader";
  inherit version;

  src =
    let
      selectSystem =
        attrs:
        attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      arch = selectSystem {
        aarch64-linux = "arm64";
        armv7l-linux = "armhf";
        x86_64-linux = "amd64";
      };
    in
    fetchurl {
      url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-${arch}.deb";
      hash = selectSystem {
        aarch64-linux = "sha256-OWhTlVEw1Sj7ZBE6/vTMwt67nP/qzBi47ZOtUZ2aBeo=";
        armv7l-linux = "sha256-NOlyh+q0WAsSD8r4MH0jVfRvxBmqkxmMzUp9Jwn5u+s=";
        x86_64-linux = "sha256-nzQdfc9bo0RCpa9sGH0rc7RBnR6Z0z6NIyJcYogNhCw=";
      };
    };

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];
  buildInputs = [
    glib
    gnutar
    gtk3-x11
    luajit_lua52
    sdcv
    SDL2
    openssl
  ];

  installPhase = ''
    runHook preInstall

    cp --recursive usr $out
  ''
  # Link required binaries
  + ''
    ln -sf ${luajit_lua52}/bin/luajit $out/lib/koreader/luajit
    ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
    ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar
  ''
  # Link SSL/network libraries
  + ''
    ln -sf ${openssl.out}/lib/libcrypto.so.3 $out/lib/koreader/libs/libcrypto.so.1.1
    ln -sf ${openssl.out}/lib/libssl.so.3 $out/lib/koreader/libs/libssl.so.1.1
  ''
  # Copy fonts
  + ''
    find ${src_repo}/resources/fonts -type d -execdir cp -r '{}' $out/lib/koreader/fonts \;
  ''
  # Remove broken symlinks
  + ''
    find $out -xtype l -print -delete
  ''
  + ''
    wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : $out/lib/koreader/libs:${
      lib.makeLibraryPath [
        gtk3-x11
        SDL2
        glib
        stdenv.cc.cc
        openssl.out
      ]
    }

    runHook postInstall
  '';

  passthru = {
    inherit src_repo;
    updateScript = writeScript "update-koreader" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p nix curl jq nix-update common-updater-scripts
      set -eou pipefail
      version=$(nix eval --raw --file . koreader.version)
      nix-update koreader
      latestVersion=$(nix eval --raw --file . koreader.version)
      if [[ "$latestVersion" == "$version" ]]; then
        exit 0
      fi
      update-source-version koreader $latestVersion --source-key=src_repo --ignore-same-version
      systems=$(nix eval --json -f . koreader.meta.platforms | jq --raw-output '.[]')
      for system in $systems; do
        hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url $(nix eval --raw -f . koreader.src.url --system "$system")))
        update-source-version koreader $latestVersion $hash --system=$system --ignore-same-version --ignore-same-hash
      done
    '';
  };

  meta = {
    homepage = "https://github.com/koreader/koreader";
    changelog = "https://github.com/koreader/koreader/releases/tag/v${version}";
    description = "Ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    mainProgram = "koreader";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
      "x86_64-linux"
    ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      contrun
      liberodark
    ];
  };
}
