{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "snowflake";
  version = "2.12.1";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3aXO6AvOHPX8QCXK5dFx3QVxQ7BNAi4DJAZ63BMOI1g=";
  };

  vendorHash = "sha256-X7SfTTxUL/4f2OndF8gnhz5JVpqGzeGLctiOFx5pJPI=";

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
