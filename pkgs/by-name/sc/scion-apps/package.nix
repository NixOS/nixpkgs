{
  lib,
  buildGoModule,
  fetchFromGitHub,
  openpam,
}:

buildGoModule {
  pname = "scion-apps";
  version = "unstable-2025-03-12";

  src = fetchFromGitHub {
    owner = "netsec-ethz";
    repo = "scion-apps";
    rev = "55667b489898af09ae9d8290410da0be176549f9";
    hash = "sha256-Tj0vtdYDmKbMpcO+t9KrtFewqdjusr0JRXpX6gY69WM=";
  };

  vendorHash = "sha256-/gBtKgCDyoCnJLfH5WgTCdOvoYRpPn8x2OHW0uYQnGQ=";

  overrideModAttrs = old: {
    # https://gitlab.com/cznic/libc/-/merge_requests/10
    postBuild = ''
      patch -p0 < ${./darwin-sandbox-fix.patch}
    '';
  };

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
    "-w"
  ];

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
