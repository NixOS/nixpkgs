{
  buildGoModule,
  fetchFromGitiles,
  lib,
}:
let
  commit = "500493c154652d6986a34b341e98df244ae1ad0d";
  git-repo = "https://chromium.googlesource.com/infra/luci/luci-go";
in
buildGoModule {
  pname = "luci-go";
  version = "0-unstable-2024-10-31";

  src = fetchFromGitiles {
    url = git-repo;
    rev = commit;
    hash = "sha256-HP4Aizt5FJA3IAlqs7gylw8/xUbBwsmReGaR8jIkmrk=";
  };

  vendorHash = "sha256-FMqbEls6MivPeReZTADrfcAvxo8o0Gy7bq9xG6WN38k=";

  checkFlags =
    let
      skippedTests = [
        # require network access
        "TestDownloadInputs"
        "TestInstallCipd"
        "TestIsLocalAddr"
        "TestGenerateSignedURL"

        # require filesystem access
        "TestPythonBasic"
        "TestPythonFromPath"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "LUCI services and tools in Go";
    longDescription = ''
      LUCI services and tools in Go. This is part of Chromium infra and
      provides facilities useful for packaging software from the Chromium
      ecosystem.
    '';
    homepage = "${git-repo}/";
    changelog = "${git-repo}/+log?s=${commit}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gm6k ];
  };
}
