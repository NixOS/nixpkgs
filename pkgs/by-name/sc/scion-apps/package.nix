{
  lib,
  buildGoModule,
  fetchFromGitHub,
  openpam,
}:

buildGoModule {
  pname = "scion-apps";
  version = "unstable-2024-04-05";

  src = fetchFromGitHub {
    owner = "netsec-ethz";
    repo = "scion-apps";
    rev = "cb0dc365082788bcc896f0b55c4807b72c2ac338";
    hash = "sha256-RzWtnUpZfwryOfumgXHV5QMceLY51Zv3KI0K6WLz8rs=";
  };

  vendorHash = "sha256-bz4vtELxrDfebk+00w9AcEiK/4skO1mE3lBDU1GkOrk=";

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
