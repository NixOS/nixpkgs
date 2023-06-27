{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "23.6.2";
  sha256 = "1jvvywd1m87ivdcwzmi6cc9k4a53wsvmxac4v80rlqvmhaj1jq62";
  vendorSha256 = "sha256-fBpF4UZaO7EtCzjzF3lg6Hea/tEOmmwRVEwNono32LU=";
}
