{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "snowflake";
  version = "2.14.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-MvV1kP+Xm3a4Q8+YZLwC9vpVK54ltb73cRkJhReSA2U=";
  };

  vendorHash = "sha256-onxJDRURyQIA+t4PbuIk14VkVUFnuALTteF9nfMZuBY=";

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
