{
  buildGoModule,
  lib,
  fetchFromGitHub,
  curl-impersonate-chrome,
  pkg-config,
  curl,
}:

buildGoModule rec {
  pname = "blackbeard";
  version = "0-unstable-2024-01-02";

  src = fetchFromGitHub {
    owner = "matheusfillipe";
    repo = "BlackBeard";
    rev = "788be485df436bf009e716c9918c395bda8d86f4";
    hash = "sha256-2i7r3asDBEBSUVOR+n3C+DH2HLeE2sbVJp95jfE/UpQ=";
  };

  vendorHash = "sha256-4cUoI8OcBCUT3uqvmIduCj0My8LCVUoDvvAS21DR2Mo=";

  nativeBuildInputs = [
    pkg-config
  ];

  preBuild = ''
    export TEMP=$(mktemp -d)
    pushd $TEMP
    # curl-impersonate-chrome being a fork of curl emulating real browsers, and having to patch curl's existing pkgconfig file since curl-impersonate-chrome doesn't come with one
    cp ${curl.dev}/lib/pkgconfig/libcurl.pc .
    substituteInPlace libcurl.pc \
      --replace-fail "${curl.out}" "${curl-impersonate-chrome}" \
      --replace-fail "-lcurl" "-lcurl-impersonate-chrome"
    popd
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$TEMP
  '';

  doCheck = false;
  # All tests need network

  buildInputs = [
    curl-impersonate-chrome
  ];

  meta = {
    homepage = "https://github.com/matheusfillipe/blackbeard/";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    description = "API and CLI written in Go that scrapes content from video providers";
    mainProgram = "blackbeard";
  };
}
