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
  version = "unstable-2024-02-14";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "1d6cd8c35f4c4a1279084ae974ecfcf73a426743";
    hash = "sha256-wfeWbdMfxlYtLMj+xrgBORfs/MdcaM3tncpNSXi1K9E=";
  };

  vendorHash = "sha256-Jmo8y4qZYvrk7gpsWpesBw0T2IW5Bb+Irs3ExW/DjUs=";

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
