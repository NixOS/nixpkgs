{ lib, stdenv, rustPlatform, fetchFromBitbucket, Libsystem, SystemConfiguration, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "bore";
  version = "0.4.1";

  src = fetchFromBitbucket {
    owner = "delan";
    repo = "nonymous";
    rev = "${pname}-${version}";
    sha256 = "1fdnnx7d18gj4rkv1dc6q379dqabl66zks9i0rjarjwcci8m30d9";
  };

  cargoHash = "sha256-vUKv98lfsrxBiJxjL8ZKLZ1IVCX5hHzl+F5y4Ot3i/Y=";
  cargoBuildFlags = [ "-p" pname ];

  # error[E0793]: reference to packed field is unaligned
  doCheck = !stdenv.hostPlatform.isDarwin;

  # FIXME can’t test --all-targets and --doc in a single invocation
  cargoTestFlags = [ "--all-targets" "--workspace" ];
  checkFeatures = [ "std" ];

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional stdenv.hostPlatform.isDarwin rustPlatform.bindgenHook;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Libsystem
    SystemConfiguration
  ];

  postInstall = ''
    installManPage $src/bore/doc/bore.1
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    printf '\0\0\0\0\0\0\0\0\0\0\0\0' \
    | $out/bin/bore --decode \
    | grep -q ';; NoError #0 Query 0 0 0 0 flags'
  '';

  meta = with lib; {
    description = "DNS query tool";
    homepage = "https://crates.io/crates/bore";
    license = licenses.isc;
    maintainers = [ ];
    mainProgram = "bore";
    broken = stdenv.hostPlatform.isDarwin; # bindgen fails on: "in6_addr_union_(...)" is not a valid Ident
  };
}
