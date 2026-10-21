{
  lib,
  buildGoModule,
  coreutils,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "sing-box";
  version = "1.13.19";

  __structuredAttrs = true;

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "sing-box";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gXl4fW7iwWylxFBdipU2fKM4yYtfPjI/Hv/19XxkuXA=";
  };

  # Remove distrusted CA certificates from the embedded root stores.
  # TODO: Remove once upstream updates its bundled CA certificates.
  postPatch = ''
    for cert in \
      "AAA Certificate Services" \
      "emSign ECC Root CA - G3" \
      "emSign Root CA - C1" \
      "emSign ECC Root CA - C3"; do
      grep -Eq "^[[:space:]]*// $cert$" common/certificate/mozilla.go
    done
    grep -Fq '// CN=emSign ECC Root CA - G3;' common/certificate/chrome.go

    sed -i -E \
      '/^[[:space:]]*\/\/ (CN=)?(AAA Certificate Services|emSign ECC Root CA - G3|emSign Root CA - C1|emSign ECC Root CA - C3)(;|$)/,/^-----END CERTIFICATE-----/d' \
      common/certificate/{mozilla,chrome}.go
  '';

  vendorHash = "sha256-nNFqDOvM8bwCRNG399dU24XO+mmal+YAE7EoPghUaZo=";

  tags = [
    "with_gvisor"
    "with_quic"
    "with_dhcp"
    "with_wireguard"
    "with_utls"
    "with_acme"
    "with_clash_api"
    "with_tailscale"
    "with_ccm"
    "with_ocm"
    "badlinkname"
    "tfogo_checklinkname0"
  ];

  subPackages = [
    "cmd/sing-box"
  ];

  env = {
    CGO_ENABLED = 0;
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-X=github.com/sagernet/sing-box/constant.Version=${finalAttrs.version}"
    "-X=internal/godebug.defaultGODEBUG=multipathtcp=0"
    "-checklinkname=0"
  ];

  # no tests
  doCheck = false;

  postInstall = ''
    installShellCompletion release/completions/sing-box.{bash,fish,zsh}

    substituteInPlace release/config/sing-box{,@}.service \
      --replace-fail "/usr/bin/sing-box" "$out/bin/sing-box" \
      --replace-fail "/bin/kill" "${coreutils}/bin/kill"
    install -Dm444 -t "$out/lib/systemd/system/" release/config/sing-box{,@}.service

    install -Dm444 release/config/sing-box.rules $out/share/polkit-1/rules.d/sing-box.rules
    install -Dm444 release/config/sing-box-split-dns.xml $out/share/dbus-1/system.d/sing-box-split-dns.conf
  '';

  passthru = {
    tests = { inherit (nixosTests) sing-box; };
  };

  meta = {
    homepage = "https://sing-box.sagernet.org";
    description = "Universal proxy platform";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      nickcao
      prince213
      moraxyc
    ];
    mainProgram = "sing-box";
  };
})
