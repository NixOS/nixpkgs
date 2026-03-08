{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  libfido2,
  openssl,
  libcbor,
}:
let
  darwin_arch = if stdenv.hostPlatform.system == "aarch64-darwin" then "arm64" else "amd64";
  darwin_configure = ''
    chmod -R +w vendor/github.com/olastor/go-libfido2
    cat << EOF > vendor/github.com/olastor/go-libfido2/fido2_static_${darwin_arch}.go
    package libfido2

    /*
    #cgo darwin LDFLAGS: -framework CoreFoundation -framework IOKit -L${lib.getLib openssl}/lib -L${lib.getLib libcbor}/lib -lfido2
    #cgo darwin CFLAGS: -I${libfido2.dev}/include -I${openssl.dev}/include
    */
    import "C"
    EOF
  '';
in
buildGoModule (finalAttrs: {
  pname = "age-plugin-fido2-hmac";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "olastor";
    repo = "age-plugin-fido2-hmac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8DO62uISwleJB/NFH7U8xhfT5bcda+d+7U6LXvySsD0=";
  };

  vendorHash = "sha256-3r/eTaa4kYRXqq7sUZzzGkgcF8lZbPZguoHb6W6t1T0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  buildInputs = [ libfido2 ];

  postConfigure = lib.optional stdenv.hostPlatform.isDarwin darwin_configure;

  meta = {
    description = "Age plugin to encrypt files with fido2 tokens using the hmac-secret extension and non-discoverable credentials";
    homepage = "https://github.com/olastor/age-plugin-fido2-hmac/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "age-plugin-fido2-hmac";
  };
})
