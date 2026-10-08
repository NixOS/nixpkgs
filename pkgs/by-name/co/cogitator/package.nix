{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cogitator";
  version = "0.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LeechoShoop";
    repo = "cogitator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1v7OXCgjvTrFhSpGgnnfre2oSfSldKj52xSJq/6YtiU=";
  };

  cargoHash = "sha256-FJP5Gg8EvfTxms7mX9J6wW9HM3nYAxILUS1Oj7iedn4=";

  # netstat2 0.9.1's glob imports of libc and its own ffi types are ambiguous
  # with newer libc versions that now define __be16/tcp_info themselves
  postPatch = ''
        netstat2Dir="../${finalAttrs.pname}-${finalAttrs.version}-vendor/source-registry-0/netstat2-0.9.1/src/integrations/linux"
        substituteInPlace "$netstat2Dir/ffi/structs.rs" \
          --replace-fail \
            'use crate::integrations::linux::ffi::types::*;' \
            'use crate::integrations::linux::ffi::types::*;
    use crate::integrations::linux::ffi::types::__be16;'
        substituteInPlace "$netstat2Dir/netlink_iterator.rs" \
          --replace-fail \
            '*const tcp_info' \
            '*const crate::integrations::linux::ffi::tcp_info'
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  checkFlagsArray = [
    # Tests are broken
    "--skip=proxy_guard::tests::relative_uri_no_host_header_falls_back_to_tunnel_host"
    "--skip=spider::tests::audit_html_flags_potential_token_leak_without_panicking"
  ];

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mv $out/bin/Cogitator $out/bin/$pname
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal TLS MITM intercepting proxy and web security toolkit";
    homepage = "https://github.com/LeechoShoop/cogitator";
    changelog = "https://github.com/LeechoShoop/cogitator/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cogitator";
  };
})
