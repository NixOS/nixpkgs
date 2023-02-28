{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-AtwwLRZx9O8IWPFgFI/ZK0tbeshEmaKpTQxA1PepnWM=";
  };

  vendorHash = "sha256-gPF4XrUqDDJCCY1zrUr3AXDG0uoADR8LBxRP4yolcug=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
