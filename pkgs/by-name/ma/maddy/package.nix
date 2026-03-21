{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pam,
  coreutils,
  installShellFiles,
  scdoc,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "maddy";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+tj2h1rAdr0SPgLGGzVf5sdFmhcwY76fkMm2P/gYFuo=";
  };

  vendorHash = "sha256-+xsG7z2wSxoZ1vEJIDBtwDMiU7zKCtZOsYPUhv6HMpQ=";

  tags = [ "libpam" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/foxcpp/maddy.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/maddy" ];

  buildInputs = [ pam ];

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postInstall = ''
    for f in docs/man/*.scd; do
      local page="docs/man/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    ln -s "$out/bin/maddy" "$out/bin/maddyctl"

    mkdir -p $out/lib/systemd/system

    substitute dist/systemd/maddy.service $out/lib/systemd/system/maddy.service \
      --replace "/usr/local/bin/maddy" "$out/bin/maddy" \
      --replace "/bin/kill" "${coreutils}/bin/kill"

    substitute dist/systemd/maddy@.service $out/lib/systemd/system/maddy@.service \
      --replace "/usr/local/bin/maddy" "$out/bin/maddy" \
      --replace "/bin/kill" "${coreutils}/bin/kill"
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=strict-prototypes";

  passthru.tests.nixos = nixosTests.maddy;

  meta = {
    description = "Composable all-in-one mail server";
    homepage = "https://maddy.email";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
