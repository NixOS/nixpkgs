{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dblab";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "danvergara";
    repo = "dblab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0tkIDWAub+wfoJ760m1kU7XYnGNner/zLtCod6UPF60=";
  };

  vendorHash = "sha256-UGnbXjXnZ3EVcAk0ZTaV2wWWXv5nsbyNlTv8PMl2rP4=";
  # Fix case-insensitive conflicts producing platform-dependent checksums
  # https://github.com/microsoft/go-mssqldb/issues/234
  proxyVendor = true;

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  doCheck = true;
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # modernc reads /etc/protocols during package init, which Darwin sandboxing blocks.
    go mod download modernc.org/libc
    chmod -R u+w "$GOPATH/pkg/mod/modernc.org/libc@"*
    substituteInPlace "$GOPATH"/pkg/mod/modernc.org/libc@*/honnef.co/go/netdb/netdb.go \
      --replace-fail '!os.IsNotExist(err)' '!os.IsNotExist(err) && !os.IsPermission(err)'
  '';
  checkFlags = [
    "-short"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Tries to bind a local TCP listener, which Darwin sandboxing blocks.
    "-skip=^TestSSHKeyFileAuthentication$"
  ];

  meta = {
    description = "Database client every command line junkie deserves";
    longDescription = ''
      Fast and lightweight interactive terminal-based UI application
      for PostgreSQL, MySQL, SQLite, Oracle, and SQL Server.
    '';
    homepage = "https://github.com/danvergara/dblab";
    changelog = "https://github.com/danvergara/dblab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "dblab";
  };
})
