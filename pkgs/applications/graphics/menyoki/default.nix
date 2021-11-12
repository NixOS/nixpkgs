{ fetchFromGitHub
, installShellFiles
, lib
, pkg-config
, rustPlatform
, stdenv
, libX11
, libXrandr
, withSki ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "menyoki";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "050c6c60il6cy0a8d3nw4z2cyp043912a7n4n44yjpmx047w7kc7";
  };

  cargoSha256 = "0wwcda2w8jg3q132cvhdgfmjc0rz93fx6fai93g5w8br98aq9qzx";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optional stdenv.isLinux pkg-config;

  buildInputs = lib.optionals stdenv.isLinux [ libX11 libXrandr ];

  cargoBuildFlags = lib.optional (!withSki) "--no-default-features";

  postInstall = ''
    installManPage man/*
    installShellCompletion completions/menyoki.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Screen{shot,cast} and perform ImageOps on the command line";
    homepage = "https://menyoki.cli.rs/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    broken = stdenv.isDarwin;
  };
}
