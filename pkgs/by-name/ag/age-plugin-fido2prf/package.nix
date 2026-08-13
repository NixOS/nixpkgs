{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libfido2,
}:
buildGoModule (finalAttrs: {
  pname = "age-plugin-fido2prf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "typage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JGEn1xIzfLyoCWd/aRRG08Z/OoviEyZF+tGEfcj9DXw=";
  };

  srcRoot = "${finalAttrs.src}/fido2prf/cmd/age-plugin-fido2prf";
  vendorHash = "sha256-XrgZBvNyVUhKJ87vfd9aZh6aW+JifJWUu/ggNQZKwo0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  buildInputs = [ libfido2 ];

  postConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    chmod -R +w vendor/github.com/keys-pub/go-libfido2
    substituteInPlace vendor/github.com/keys-pub/go-libfido2/fido2_static_arm64.go \
      --replace-fail \
        '/opt/homebrew/opt/libfido2/lib/libfido2.a /opt/homebrew/opt/openssl@3/lib/libcrypto.a ''${SRCDIR}/darwin/arm64/lib/libcbor.a' \
        '-lfido2' \
      --replace-fail \
        '-I/opt/homebrew/opt/libfido2/include -I/opt/homebrew/opt/openssl@3/include' \
        '-I${libfido2.dev}/include'
    substituteInPlace vendor/github.com/keys-pub/go-libfido2/fido2_static_amd64.go \
      --replace-fail \
        '/usr/local/lib/libfido2.a /usr/local/opt/openssl@3/lib/libcrypto.a ''${SRCDIR}/darwin/amd64/lib/libcbor.a' \
        '-lfido2' \
      --replace-fail \
        '-I/usr/local/opt/libfido2/include -I/usr/local/opt/openssl@3/include' \
        '-I${libfido2.dev}/include'
  '';

  meta = {
    description = "Age plugin to encrypt files with FIDO2 tokens in a way compatible to typage";
    homepage = "https://github.com/FiloSottile/typage/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ claraphyll ];
    mainProgram = "age-plugin-fido2prf";
  };
  __structuredAttrs = true;
})
