{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  openpam,
}:

buildGoModule {
  pname = "scion-apps";
  version = "0.6.0-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "netsec-ethz";
    repo = "scion-apps";
    rev = "6c990ccb5b39fe0f7a23a3d8dcb4528439c3f5c5";
    hash = "sha256-qbz6lGnCSzIH0r1nJ5+oAQquiehRBw7hxgEfbXM1/Yc=";
  };

  vendorHash = "sha256-svC4FlQ/e5XjPKuHBYPvqy5l8nWWQTdg1Bf4KSANrMw=";

  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace webapp/web/tests/health/scmpcheck.sh \
      --replace-fail "hostname -I" "hostname -i"
  '';

  postInstall = ''
    # Add `scion-` prefix to all binaries
    for f in $out/bin/*; do
      filename="$(basename "$f")"
      mv -v $f $out/bin/scion-$filename
    done

    # Fix nested subpackage names
    mv -v $out/bin/scion-server $out/bin/scion-ssh-server
    mv -v $out/bin/scion-client $out/bin/scion-ssh-client

    # Include static website for webapp
    mkdir -p $out/share
    cp -r webapp/web $out/share/scion-webapp
  '';

  buildInputs = [
    openpam
  ];

  checkFlags = [ "-skip=^(TestMangleSCIONAddrURL|TestRoundTripper)$" ];

  ldflags = [
    "-s"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };

  meta = {
    description = "Public repository for SCION applications";
    homepage = "https://github.com/netsec-ethz/scion-apps";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      matthewcroughan
      sarcasticadmin
    ];
  };
}
