{
  lib,
  buildGoModule,
  fetchFromGitHub,
  openssl,
  pkg-config,
  libpcap,
  nix-update-script,
  krb5,
}:

buildGoModule (finalAttrs: {
  pname = "mongo-tools";
  version = "100.14.1";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-tools";
    tag = finalAttrs.version;
    hash = "sha256-+3Cmaa0913TKj/nMmTxXQeegPEZ1NUdusTbKZ86LqLY=";
  };

  vendorHash = null;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libpcap
    krb5
  ];

  # Mongodb incorrectly names all of their binaries main
  # Let's work around this with our own installer
  buildPhase =
    let
      tools = [
        "bsondump"
        "mongodump"
        "mongoexport"
        "mongofiles"
        "mongoimport"
        "mongorestore"
        "mongostat"
        "mongotop"
      ];
    in
    ''
      # move vendored codes so nixpkgs go builder could find it
      runHook preBuild

      ${lib.concatMapStrings (t: ''
        go build -o "$out/bin/${t}" -tags "gssapi ssl" -ldflags "-s -w" ./${t}/main
      '') tools}

      runHook postBuild
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/mongodb/mongo-tools";
    description = "Tools for the MongoDB";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      iamanaws
    ];
  };
})
