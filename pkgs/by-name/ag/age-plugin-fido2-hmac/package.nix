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
    chmod -R +w vendor/github.com/keys-pub/go-libfido2
    cat << EOF > vendor/github.com/keys-pub/go-libfido2/fido2_static_${darwin_arch}.go
    package libfido2

    /*
    #cgo darwin LDFLAGS: -framework CoreFoundation -framework IOKit -L${lib.getLib openssl}/lib -L${lib.getLib libcbor}/lib -lfido2
    #cgo darwin CFLAGS: -I${libfido2.dev}/include -I${openssl.dev}/include
    */
    import "C"
    EOF
  '';
in
buildGoModule rec {
  pname = "age-plugin-fido2-hmac";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "olastor";
    repo = "age-plugin-fido2-hmac";
    rev = "v${version}";
    hash = "sha256-P2gNOZeuODWEb/puFe6EA1wW3pc0xgM567qe4FKbFXg=";
  };

  vendorHash = "sha256-h4/tyq9oZt41IfRJmmsLHUpJiPJ7YuFu59ccM7jHsFo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  buildInputs = [ libfido2 ];

  postConfigure = lib.optional stdenv.hostPlatform.isDarwin darwin_configure;

  meta = with lib; {
    description = "Age plugin to encrypt files with fido2 tokens using the hmac-secret extension and non-discoverable credentials";
    homepage = "https://github.com/olastor/age-plugin-fido2-hmac/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "age-plugin-fido2-hmac";
  };
}
