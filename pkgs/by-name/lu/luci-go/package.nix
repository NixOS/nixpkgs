{
  buildGoModule,
  fetchFromGitiles,
  lib,
  git,
}:
let
  commit = "b6bffbd35b309667f3716491c3fa51fae5b6f169";
  git-repo = "https://chromium.googlesource.com/infra/luci/luci-go";
in
buildGoModule {
  pname = "luci-go";
  version = "0-unstable-2025-08-26";

  src = fetchFromGitiles {
    url = git-repo;
    rev = commit;
    hash = "sha256-vKASbHcu50l/kAUI5yAjOssjRKjsx0VxKQB7b3HprSI=";
  };

  vendorHash = "sha256-4BiC5LI7mG7jCz2dt+Wj+MTqzif68C+TAf/0JNExuYg=";

  preCheck = ''
    export PATH="${git}/bin:$PATH"
  '';

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

        # incompatible with our sandbox
        "TestFindRoot"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "LUCI services and tools in Go";
    longDescription = ''
      LUCI services and tools in Go. This is part of Chromium infra and
      provides facilities useful for packaging software from the Chromium
      ecosystem. Provides cipd.
    '';
    homepage = "${git-repo}/";
    changelog = "${git-repo}/+log?s=${commit}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gm6k ];
  };
}
