{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "snowflake";
  version = "2.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${version}";
    sha256 = "sha256-QyTyFz4NIuUV7g5f6qV/ujfHYZDnnZmjeBinvcWlo0U=";
  };

  vendorHash = "sha256-Qn8JFzrLCUrr6WGvVmaSYC7ooiMGl8iPMXkRvALho1A=";

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
