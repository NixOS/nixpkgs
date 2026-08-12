{
  version = "26.803.81509";

  sources = {
    x86_64-linux = {
      url =
        "https://"
        + "persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
      hash = "sha256-qb+Ro2j598Tuo4CCqfuPtGuNAFtxmm13FdLloZgsOOs=";
    };

    aarch64-linux = {
      url =
        "https://"
        + "persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_arm64.deb";
      hash = "sha256-84/MGU7KmrAyfcEMkjQGgernfF11Fk33ADhM4q2sy8E=";
    };
  };
}
