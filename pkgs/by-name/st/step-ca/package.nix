{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  buildGoModule,
  coreutils,
  pcsclite,
  pkg-config,
  hsmSupport ? true,
  nixosTests,
}:

buildGoModule rec {
  pname = "step-ca";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "smallstep";
    repo = "certificates";
    tag = "v${version}";
    # Source uses git export-subst and isn't reproducible when fetching as git archive,
    # see https://github.com/smallstep/certificates/blob/6a1250131284dce4aa66c0e0e3f7a3202dd56ad0/.gitattributes.
    # Use forceFetchGit to fetch the source as git repo, as fetchGit isn't effected,
    # see https://github.com/NixOS/nixpkgs/issues/84312#issuecomment-2475948960.
    forceFetchGit = true;
    hash = "sha256-TFpgVE394r6FkRWovlmDd3v/tGic2CekmO1Hp7S6KCE=";
  };

  vendorHash = "sha256-9PlJaB3BCwoE+uFo5jUggANSH7ZWnintZYBgFL21LZ4=";

  ldflags = [
    "-w"
    "-X main.Version=${version}"
  ];

  nativeBuildInputs = lib.optionals hsmSupport [ pkg-config ];

  buildInputs = lib.optionals (hsmSupport && stdenv.hostPlatform.isLinux) [ pcsclite ];
  postPatch = ''
    substituteInPlace authority/http_client_test.go --replace-fail 't.Run("SystemCertPool", func(t *testing.T) {' 't.Skip("SystemCertPool", func(t *testing.T) {'
    substituteInPlace systemd/step-ca.service --replace "/bin/kill" "${coreutils}/bin/kill"
  '';

  preBuild = ''
    ${lib.optionalString (!hsmSupport) "export CGO_ENABLED=0"}
  '';

  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system systemd/step-ca.service
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Tests start http servers which need to bind to local addresses:
  # panic: httptest: failed to listen on a port: listen tcp6 [::1]:0: bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  # Tests need to run in a reproducible order, otherwise they run unreliably on
  # (at least) x86_64-linux.
  checkFlags = [ "-p 1" ];

  passthru.tests.step-ca = nixosTests.step-ca;

  meta = {
    description = "Private certificate authority (X.509 & SSH) & ACME server for secure automated certificate management, so you can use TLS everywhere & SSO for SSH";
    homepage = "https://smallstep.com/certificates/";
    changelog = "https://github.com/smallstep/certificates/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "step-ca";
    maintainers = with lib.maintainers; [
      cmcdragonkai
      techknowlogick
    ];
  };
}
