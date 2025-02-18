{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "snowflake";
  version = "2.10.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-cpvLBC4mGz4iSP+d3qyKBtCkXNvC8YJ04nIbZuR/15M=";
  };

  vendorHash = "sha256-wCgG6CzxBAvhMICcmDm9a+JdtWs+rf3VU1XAICsc170=";

  meta = with lib; {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${version}/ChangeLog";
    maintainers = with maintainers; [
      bbjubjub
      yayayayaka
    ];
    license = licenses.bsd3;
  };
}
