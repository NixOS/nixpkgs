{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dasel";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:11xm47p7n79mq2zkv9q9m5v4a1gga01pkzi2j42gq1ma9hwz4idz";
  };

  vendorSha256 = "sha256:1552k85z4s6gv7sss7dccv3h8x22j2sr12icp6s7s0a3i4iwyksw";

  meta = with stdenv.lib; {
    description = "Query and update data structures from the command line";
    longDescription = ''
      Dasel (short for data-selector) allows you to query and modify data structures using selector strings.
      Comparable to jq / yq, but supports JSON, YAML, TOML and XML with zero runtime dependencies.
    '';
    homepage = "https://github.com/TomWright/dasel";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
