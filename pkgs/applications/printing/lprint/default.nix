{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  pappl,
}:

stdenv.mkDerivation rec {
  pname = "lprint";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "lprint";
    rev = "v${version}";
    hash = "sha256-KgwjYtHbVnAOxzKOevhcohRcsKFsDdYLqrQ2wCc4AVU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pappl ];

  meta = with lib; {
    description = "Label Printer Application";
    homepage = "https://www.msweet.org/lprint";
    changelog = "https://github.com/michaelrsweet/lprint/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ tmarkus ];
    platforms = platforms.unix;
  };
}
