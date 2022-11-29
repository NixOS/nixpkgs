{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.22";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-wFK5dFGD25KtBn4gujgvDu8zZWQ8XH1peEbpLa+6n8A=";
  };

  vendorSha256 = "sha256-HZrchLQ1861MYWDiiegXLNMDsDUzRNzLA7MoULBai+4=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
