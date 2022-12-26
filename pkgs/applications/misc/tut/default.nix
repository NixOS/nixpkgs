{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.26";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZSlrPhCArPEVTKX7BbUfKA+hYi7TpmJbGjWmbBUwes0=";
  };

  vendorSha256 = "sha256-PYVXEPmWgtME3XljJzyGAri/GW19PIkQpscFFRNuVXQ=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
