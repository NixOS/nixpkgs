{
  lib,
  fetchFromGitHub,
  libpcap,
  libseccomp,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "sniffglue";
    rev = "v${version}";
    hash = "sha256-Pp/SJJQFpEU/4GKZQB8BjRGS4hqB850QbSb5WoG6Wh4=";
  };

  cargoHash = "sha256-4aOp9z1xAZ4+GfvcP4rwiS35BfNBnftNhK/oJDixa8w=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libseccomp
  ];

  meta = with lib; {
    description = "Secure multithreaded packet sniffer";
    homepage = "https://github.com/kpcyrd/sniffglue";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "sniffglue";
  };
}
