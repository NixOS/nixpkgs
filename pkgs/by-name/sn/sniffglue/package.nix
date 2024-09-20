{ lib
, fetchFromGitHub
, libpcap
, libseccomp
, pkg-config
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Pp/SJJQFpEU/4GKZQB8BjRGS4hqB850QbSb5WoG6Wh4=";
  };

  cargoHash = "sha256-/MGrdo8cmodC3oVWk6y8C73gsLKROmNOI9aytPPzA8o=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap
  ] ++ lib.optionals stdenv.isLinux [
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
