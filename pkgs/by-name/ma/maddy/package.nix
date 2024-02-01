{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pam
, coreutils
, installShellFiles
, scdoc
, nixosTests
}:

buildGoModule rec {
  pname = "maddy";
  version = "unstable-2024-01-29";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "4a69c9e9441014bd4631a5ba444b95db21d800d3";
    hash = "sha256-MLfgHANsowvDbUxSIXeXRWcXcUuUIO9fSCaEFGPuJHY=";
  };

  vendorHash = "sha256-FKtPmCYZMN+HGaL7tZdoJfRNuCVjWuJ+NytETausakY=";

  tags = [ "libpam" ];

  ldflags = [ "-s" "-w" "-X github.com/foxcpp/maddy.Version=${version}" ];

  subPackages = [ "cmd/maddy" ];

  buildInputs = [ pam ];

  nativeBuildInputs = [ installShellFiles scdoc ];

  postInstall = ''
    for f in docs/man/*.scd; do
      local page="docs/man/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    ln -s "$out/bin/maddy" "$out/bin/maddyctl"

    mkdir -p $out/lib/systemd/system

    substitute dist/systemd/maddy.service $out/lib/systemd/system/maddy.service \
      --replace-fail "/usr/local/bin/maddy" "$out/bin/maddy" \
      --replace-fail "/bin/kill" "${coreutils}/bin/kill"

    substitute dist/systemd/maddy@.service $out/lib/systemd/system/maddy@.service \
      --replace-fail "/usr/local/bin/maddy" "$out/bin/maddy" \
      --replace-fail "/bin/kill" "${coreutils}/bin/kill"
  '';

  passthru.tests.nixos = nixosTests.maddy;

  meta = with lib; {
    description = "Composable all-in-one mail server";
    homepage = "https://maddy.email";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao onny ];
  };
}
