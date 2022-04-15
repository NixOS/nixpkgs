{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "flex-ncat";
  version = "0.1-20211223.0";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    rev = "v${version}";
    hash = "sha256-l5IH6EtWqxMLqUfIYpaKgZE9Jq8q4+WgZIazQ2scyxg=";
  };

  vendorSha256 = "sha256-OzYlpC8DZQc3qo7mnl5jHlxaCNxMW+Z3VG535e+G/1o=";

  meta = with lib; {
    homepage = "https://github.com/kc2g-flex-tools/nCAT";
    description = "FlexRadio remote control (CAT) via hamlib/rigctl protocol";
    license = licenses.mit;
    maintainers = with maintainers; [ mvs ];
    mainProgram = "nCAT";
  };
}
