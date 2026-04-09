{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "snowflake";
  version = "2.13.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XbBlUEkv0ptrb+X+oPDRCvy6HE6XHgSSLwFTXw071pU=";
  };

  vendorHash = "sha256-bhv7soUyZnIG+AS1mMH38GZEG74tDk/ap7cQr6k4Pzs=";

  meta = {
    description = "System to defeat internet censorship";
    homepage = "https://snowflake.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/raw/v${finalAttrs.version}/ChangeLog";
    maintainers = with lib.maintainers; [
      bbjubjub
      yayayayaka
    ];
    license = lib.licenses.bsd3;
  };
})
