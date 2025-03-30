{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gost";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "ginuerzh";
    repo = "gost";
    tag = "v${version}";
    hash = "sha256-kNhWJiPF6DlxxVZvW7HJkvzSuGsrozZBhiVaw+a7mYs=";
  };

  vendorHash = "sha256-7Wmd82sSMVAo1cGUi1EIig8h5drgy85D9FmSNtIBRqY=";

  postPatch = ''
    substituteInPlace http2_test.go \
      --replace-fail "TestH2CForwardTunnel" "SkipH2CForwardTunnel" \
      --replace-fail "TestH2ForwardTunnel" "SkipH2ForwardTunnel"

    substituteInPlace resolver_test.go \
      --replace-fail '{NameServer{Addr: "1.1.1.1"}, "github", true},' "" \
      --replace-fail '{NameServer{Addr: "1.1.1.1"}, "github.com", true},' "" \
      --replace-fail '{NameServer{Addr: "1.1.1.1:53"}, "github.com", true},' "" \
      --replace-fail '{NameServer{Addr: "1.1.1.1:53", Protocol: "tcp"}, "github.com", true},' "" \
      --replace-fail '{NameServer{Addr: "1.1.1.1:853", Protocol: "tls"}, "github.com", true},' "" \
      --replace-fail '{NameServer{Addr: "1.1.1.1:853", Protocol: "tls", Hostname: "cloudflare-dns.com"}, "github.com", true},' "" \
      --replace-fail '{NameServer{Addr: "https://cloudflare-dns.com/dns-query", Protocol: "https"}, "github.com", true},' "" \
      --replace-fail '{NameServer{Addr: "https://1.0.0.1/dns-query", Protocol: "https"}, "github.com", true},' ""

    # Skip TestShadowTCP, TestShadowUDP: #70 #71 #72 #78 #83 #85 #86 #87 #93
    substituteInPlace ss_test.go \
      --replace-fail '{url.User("xchacha20"), url.UserPassword("xchacha20", "123456"), false},' "" \
      --replace-fail '{url.UserPassword("xchacha20", "123456"), url.User("xchacha20"), false},' "" \
      --replace-fail '{url.UserPassword("xchacha20", "123456"), url.UserPassword("xchacha20", "abc"), false},' "" \
      --replace-fail '{url.UserPassword("CHACHA20-IETF-POLY1305", "123456"), url.UserPassword("CHACHA20-IETF-POLY1305", "123456"), true},' "" \
      --replace-fail '{url.UserPassword("AES-128-GCM", "123456"), url.UserPassword("AES-128-GCM", "123456"), true},' "" \
      --replace-fail '{url.User("AES-192-GCM"), url.UserPassword("AES-192-GCM", "123456"), false},' "" \
      --replace-fail '{url.UserPassword("AES-192-GCM", "123456"), url.User("AES-192-GCM"), false},' "" \
      --replace-fail '{url.UserPassword("AES-192-GCM", "123456"), url.UserPassword("AES-192-GCM", "abc"), false},' "" \
      --replace-fail '{url.UserPassword("AES-256-GCM", "123456"), url.UserPassword("AES-256-GCM", "123456"), true},' ""
  '';

  __darwinAllowLocalNetworking = true;

  # i/o timeout
  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "-V";

  meta = {
    description = "Simple tunnel written in golang";
    homepage = "https://github.com/ginuerzh/gost";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pmy ];
    mainProgram = "gost";
  };
}
