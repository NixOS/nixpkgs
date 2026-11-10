{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "snowflake";
  version = "2.15.2";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "anti-censorship/pluggable-transports";
    repo = "snowflake";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sjJ/72Rhyr1ITiGuJhPzVzzBuRWlJ2JZhiNHgFW0PLs=";
  };

  vendorHash = "sha256-vC9lq4zZaRkLoxFAEPo7vE+zY8hWknPAUX1zgv8cAmE=";

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
