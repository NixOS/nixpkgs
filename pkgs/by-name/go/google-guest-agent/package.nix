{
  lib,
  buildGoModule,
  fetchFromGitHub,
  coreutils,
  makeWrapper,
  google-guest-configs,
  google-guest-oslogin,
  iproute2,
  procps,
}:

buildGoModule rec {
  pname = "guest-agent";
  version = "20230821.00";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "guest-agent";
    tag = version;
    hash = "sha256-DP15KDnD09edBxOQDwP0cjVIFxjMzE1hu1Sbu6Faj9Y=";
  };

  vendorHash = "sha256-PGvyDjhLwIKhR6NmwzbzjfkBK+FqsziAdsybQmCbtCc=";

  patches = [ ./disable-etc-mutation.patch ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substitute ${./fix-paths.patch} fix-paths.patch \
      --subst-var out \
      --subst-var-by true "${coreutils}/bin/true"
    patch -p1 < ./fix-paths.patch
  '';

  # We don't add `shadow` here; it's added to PATH if `mutableUsers` is enabled.
  binPath = lib.makeBinPath [
    google-guest-configs
    google-guest-oslogin
    iproute2
    procps
  ];

  # Skip tests which require networking.
  preCheck = ''
    rm google_guest_agent/wsfc_test.go
  '';

  postInstall = ''
    mkdir -p $out/etc/systemd/system
    cp *.service $out/etc/systemd/system
    install -Dm644 instance_configs.cfg $out/etc/default/instance_configs.cfg

    wrapProgram $out/bin/google_guest_agent \
      --prefix PATH ":" "$binPath"
  '';

  meta = {
    description = "Guest Agent for Google Compute Engine";
    homepage = "https://github.com/GoogleCloudPlatform/guest-agent";
    changelog = "https://github.com/GoogleCloudPlatform/guest-agent/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
