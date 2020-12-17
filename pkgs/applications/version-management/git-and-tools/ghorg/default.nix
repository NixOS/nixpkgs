{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghorg";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "gabrie30";
    repo = "ghorg";
    rev = version;
    sha256 = "0diwndkckv6fga45j9zngizycn5m71r67cziv0zrx6c66ssbj49w";
  };

  doCheck = false;
  vendorSha256 = null;

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "Quickly clone an entire org/users repositories into one directory";
    longDescription = ''
      ghorg allows you to quickly clone all of an orgs, or users repos into a
      single directory. This can be useful in many situations including
      - Searching an orgs/users codebase with ack, silver searcher, grep etc..
      - Bash scripting
      - Creating backups
      - Onboarding
      - Performing Audits
    '';
    homepage = "https://github.com/gabrie30/ghorg";
    license = licenses.asl20;
    maintainers = with maintainers; [ vidbina ];
    platforms = platforms.all;
  };
}
