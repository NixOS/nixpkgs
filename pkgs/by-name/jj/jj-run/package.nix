{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (final: {
  pname = "jj-run";
  version = "7";

  src = fetchFromGitHub {
    owner = "neongreen";
    repo = "mono";
    tag = "jj-run--main.${final.version}";
    hash = "sha256-EHfM8DOp77GC+U3Xa55cnW+QC7g5psZUjCQhr/8dZlE=";
  };

  subPackages = "jj-run/cmd";

  vendorHash = "sha256-5o7jwiZs9Xn0iXDHMQ5rum9kife4ChbVSljcGPUDOIU=";

  postFixup = "mv $out/bin/cmd $out/bin/jj-run";

  meta = {
    description = "Jujutsu subcommand to execute shell commands against multiple revisions.";
    homepage = "https://github.com/neongreen/mono";
    changelog = "https:github.com/neongreen/mono/releases/tag/jj-run--main.${final.version}";
    license = lib.licenses.unlicense;
    mainProgram = "jj-run";
    maintainers = with lib.maintainers; [ nobbz ];
    platforms = with lib.platforms; unix;
  };
})
