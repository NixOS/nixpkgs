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

  vendorHash = "sha256-om6ArtnKC9Gm5BdAqW57BnE0BsOmSPAAIPDDrQ5ZmJA=";

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

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Public repository for SCION applications";
    homepage = "https://github.com/netsec-ethz/scion-apps";
    license = licenses.asl20;
    maintainers = with maintainers; [
      matthewcroughan
      sarcasticadmin
    ];
  };
}
